
use DSL::FiniteStateMachines::QueryRetrieveActFSMRole;
use DSL::FiniteStateMachines::DataObtainer::FSMGlobalCommand;
use Data::ExampleDatasets;
use Data::Reshapers;

use Text::CSV;
use XDG::BaseDirectory :terms;

#===========================================================
# DataObtainer
#===========================================================

class DSL::FiniteStateMachines::DataObtainer
        does DSL::FiniteStateMachines::QueryRetrieveActFSMRole {

    #--------------------------------------------------------
    # Metadata dataset predicate
    method is-metadata-row( $data ) {
        return $data ~~ Hash && ($data.keys (&) <Title Rows Cols CSV Doc>).elems == 5;
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'PrioritizedList',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions);

        &.re-say.(to-pretty-table($.dataset.pick(12)));
        return 'WaitForRequest';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'AcquireItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        # The parser/ actions <list-management-command> might produce a table with one row
        # or just the hash corresponding to that row.
        # If the former take the content of the table.
        if $!dataset ~~ Array {
            $!dataset = $!dataset.values[0];
        }

        &.re-say.("Acquiring data : ", $!dataset<Title>);
        my $query = '\'' ~ $!dataset<Package> ~ '::' ~ $!dataset<Item> ~ '\'';
        $!itemSpec = $!dataset<Package> ~ '::' ~ $!dataset<Item>;
        $!acquiredData = example-dataset( / <{ $query }> $ / ):keep;

        return 'ActOnItem';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ActOnItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        # Prompt selection menu
        &.re-say.( "Export dataset as [1] R-project, [2] WL-notebook, [3] Raku-package, [4] Microsoft Excel file, or [5] No export\n(choose one...)");

        # Get selection
        my $n;
        loop {
            $n = val get;
            last if $n ~~ Int && $n ~~ 1..5;
            say "Invalid input; try again.";
        }

        # Compute export names
        my $dateTimeSuffix = DateTime.now(formatter => { sprintf "%04d-%02d-%02dT%02d-%02d-%02d", .year, .month, .day, .hour, .minute, .second }).Str;
        my $projName = $!itemSpec.subst('::','-') ~ $dateTimeSuffix;

        # Export actions
        if $n == 1 {
            # R-project is selected
            my $dirName = data-home.Str ~ '/DataAcquisitionFSM/rstudio';
            $dirName ~= '/' ~ $projName;

            # Create the package
            shell "mkdir -p $dirName";
            shell "R -e 'usethis::create_project(path=\"$dirName\")'";

            # Put in the data
            shell "mkdir $dirName/data";
            my $rproj = slurp %?RESOURCES<default.Rproj>;
            csv(in => $!acquiredData, out => "$dirName/data/dataset.csv", sep => ',');

            # Copy the R-project files
            spurt("$dirName/$projName.Rproj", $rproj);

            # Open
            shell "open $dirName/$projName.Rproj"

        } elsif $n == 4 {
            # Microsoft Excel is selected

            my $dirName = data-home.Str ~ '/DataAcquisitionFSM/MSExcel';
            $dirName ~= '/' ~ $projName;

            # Create the package
            shell "mkdir -p $dirName";

            # Put in the data
            csv(in => $!acquiredData, out => "$dirName/$projName.csv", sep => ',');

            # Open
            shell "open $dirName/$projName.csv"
        }

        # Goto Exit state or stay
        return $n < 5 ?? 'ActOnItem' !! 'Exit';
    }

    #--------------------------------------------------------
    method init-dataset() {
        self.dataset = get-datasets-metadata(deepcopy=>True);
        self.initDataset = get-datasets-metadata(deepcopy=>True);
    }

    #--------------------------------------------------------
    method make-machine() {
        # Initialize attributes
        self.FSMGrammar = DSL::FiniteStateMachines::DataObtainer::FSMGlobalCommand;
        self.init-dataset();

        self.apply-query-retrieve-act-pattern();

        #--------------------------------------------------------
        # Loggers
        #--------------------------------------------------------

        self.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
        self.ECHOLOGGING = -> *@args {};

        return self;
    }
}