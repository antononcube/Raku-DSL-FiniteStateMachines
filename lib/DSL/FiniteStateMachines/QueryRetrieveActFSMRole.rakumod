
use Data::Reshapers;
use Data::Summarizers;
use Data::ExampleDatasets;

use DSL::FiniteStateMachines::FSMish;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::Shared::Roles::English::ListManagementCommand;

use DSL::English::DataQueryWorkflows::Grammar;
use DSL::English::DataQueryWorkflows::Actions::Raku::Reshapers;
use DSL::English::DataAcquisitionWorkflows::Actions::Raku::FSMCommand;
use Lingua::NumericWordForms::Roles::English::WordedNumberSpec;

#--------------------------------------------------------
role DSL::FiniteStateMachines::QueryRetrieveActFSMRole
        does DSL::FiniteStateMachines::FSMish {

    #--------------------------------------------------------
    # This dataset is supposed to be handled by the functions Data::Reshapers
    has $.dataset is rw;
    has $.initDataset is rw;
    has $.acquiredData;
    has $.itemSpec;
    has $.itemSpecCommand;
    has $.FSMGrammar is rw;

    #--------------------------------------------------------
    method init-dataset() { note 'Not overridden'; }

    #--------------------------------------------------------
    # Metadata dataset predicate
    method is-metadata-row( $data ) {
        note 'Not overridden';
        return True;
    }

    method is-metadata-dataset( $data ) {
        return ($data ~~ Array) && ([and] $data.map({ self.is-metadata-row($_) }));
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'WaitForRequest',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        # Get input if not given
        if $input.isa(Whatever) {
            $input = val get;
        }

        # Check was "global" command was entered. E.g."start over".
        my $manager = DSL::English::DataQueryWorkflows::Actions::Raku::Reshapers.new( object => $!dataset.clone);
        my $pres = $.FSMGrammar.parse($input, rule => 'TOP', actions => $manager);

        &.ECHOLOGGING.("$stateID: Global commad parsing result: ", $pres);

        if $pres<global-command><global-quit> {

            &.re-say.("$stateID: Quiting.");

            return 'Exit';

        } elsif $pres<global-command><global-cancel> {

            &.re-say.("$stateID: Starting over.");

            $!dataset = $!initDataset.clone;

            return 'WaitForRequest';

        } elsif $pres<global-command><global-show-all> {

            $!dataset = $!initDataset.clone;
            $!itemSpec = $pres;
            $!itemSpecCommand = $input;

            return 'ListOfItems';

        } elsif $pres<global-command><global-help> {

            &.re-say.("$stateID: Help.");
            &.re-say.("$stateID: Type commands for the FSM...");

            return 'WaitForRequest';

        } elsif $pres<global-command><global-priority-list> {

            return 'PriorityList';

        } elsif so $pres<global-command> {

            $.re-warn.("$stateID: No implemented reaction for the given service input.");

            # Why not just return 'WaitForRequest' ?
            return 'WaitForRequest';
        }

        &.ECHOLOGGING.("$stateID: Main commad parsing result: ", $pres);

        # If it cannot be parsed, show message
        # Maybe ...

        if not so $pres {
            return 'WaitForRequest';
        }

        # Switch to the next state
        $!itemSpecCommand = $input;
        $!itemSpec = $pres;
        return 'ListOfItems';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ListOfItems',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);
        &.ECHOLOGGING.("$stateID: itemSpec => $!itemSpec");

        if $!itemSpec<global-command><global-show-all> {

            &.re-say.(to-pretty-table($!dataset));
            return "WaitForRequest";

        }

        my $lastDataset = $!dataset.clone;

        # Get new dataset
        &.ECHOLOGGING.("Parsed: {$!itemSpec.gist}");
        if $!itemSpec<list-management-command> || $!itemSpec<workflow-commands-list> {

            use MONKEY;
            my $obj = $!dataset;
            &.ECHOLOGGING.("Interpreted: {$!itemSpec.made}");
            EVAL $!itemSpec.made;
            $!dataset = $obj;
            if $!dataset ~~ Seq { $!dataset = $!dataset.Array }

        }

        if $lastDataset eqv $!dataset {
            &.re-say.("$stateID: Pipeline value was not changed.");
            return 'WaitForRequest';
        }

        &.re-say.("$stateID: Obtained the records:");
        #`(
        say '$!dataset : ', $!dataset.raku;
        say 'self.is-metadata-row($!dataset) : ', self.is-metadata-row($!dataset);
        say 'self.is-metadata-dataset($!dataset) : ', self.is-metadata-dataset($!dataset);
        )
        if self.is-metadata-row($!dataset) {
            &.re-say.(to-pretty-table([$!dataset,]))
        } elsif self.is-metadata-dataset($!dataset) {
            &.re-say.(to-pretty-table($!dataset));
        }

        if $!dataset.elems == 0 {
            # No items
            &.re-say.("Empty set was obtained. Reverting to previous value.");
            $!dataset = $lastDataset;

            return 'WaitForRequest';

        } elsif self.is-metadata-row($!dataset) || self.is-metadata-dataset($!dataset) && $!dataset.elems == 1 {
            # One item

            return 'AcquireItem';

        } else {
            # Many items

            return 'WaitForRequest';
        }


        return 'WaitForRequest';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'PrioritizedList',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        note 'Not overridden';

        return 'WaitForRequest';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'AcquireItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        note 'Not overridden';

        return 'ActOnItem';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ActOnItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        # Prompt selection menu
        &.re-say.('Nothing to do...');

        note 'Not overridden';

        # Goto Exit state or stay
        return 'Exit';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'Help',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        return 'None';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'Exit',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        # Should we ever be here?!
        return 'None';
    }

    #--------------------------------------------------------
    method apply-query-retrieve-act-pattern() {

        #--------------------------------------------------------
        # States
        #--------------------------------------------------------
        self.add-state("WaitForRequest",   -> $obj { say "🔊 PLEASE enter item request."; });
        self.add-state("ListOfItems",      -> $obj { say "🔊 LISTING items."; });
        self.add-state("PrioritizedList",  -> $obj { say "🔊 PRIORITIZED items."; });
        self.add-state("AcquireItem",      -> $obj { say "🔊 ACQUIRE item: ", $obj.dataset[0]; });
        self.add-state("ActOnItem",        -> $obj { say "🔊 ACT ON item: ", $obj.dataset[0]; });
        self.add-state("Help",             -> $obj { say "🔊 HELP is help..."; });
        self.add-state("Exit",             -> $obj { say "🔊 SHUTTING down..."; });

        #--------------------------------------------------------
        # Transitions
        #--------------------------------------------------------
        self.add-transition("WaitForRequest",   "itemSpec",           "ListOfItems");
        self.add-transition("WaitForRequest",   "startOver",          "WaitForRequest");
        self.add-transition("WaitForRequest",   "priority",           "PrioritizedList");
        self.add-transition("WaitForRequest",   "help",               "Help");
        self.add-transition("WaitForRequest",   "quit",               "Exit");

        self.add-transition("PrioritizedList",  "priorityListGiven",  "WaitForRequest");

        self.add-transition("ListOfItems",      "manyItems",          "WaitForRequest");
        self.add-transition("ListOfItems",      "noItems",            "WaitForRequest");
        self.add-transition("ListOfItems",      "uniqueItemObtained", "AcquireItem");

        self.add-transition("AcquireItem",      "acquired",            "ActOnItem");
        self.add-transition("ActOnItem",        "actedOn",             "Exit");

        self.add-transition("Help",             "helpGiven",           "WaitForRequest");

        # Result
        return self;
    }

}