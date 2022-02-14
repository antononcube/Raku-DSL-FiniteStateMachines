
use DSL::FiniteStateMachines::QueryRetrieveActFSMRole;
use DSL::FiniteStateMachines::DataObtainer::FSMGlobalCommand;
use DSL::FiniteStateMachines::AddressBookCaller::Utilities;
use Data::Reshapers;

#===========================================================
# AddressBookCaller
#===========================================================

class DSL::FiniteStateMachines::AddressBookCaller
        does DSL::FiniteStateMachines::QueryRetrieveActFSMRole {

    #--------------------------------------------------------
    # Metadata dataset predicate
    method is-metadata-row( $data ) {
        return $data ~~ Hash && ($data.keys (&) <Name Company Position Phone Email>).elems == 5;
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

        &.re-say.("Acquiring contact info for : ", $!dataset<Name>);

        return 'ActOnItem';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ActOnItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        # Prompt selection menu
        &.re-say.( "[1] email, [2] phone message, [3] phone call, [4] discord message, or [5] nothing\n(choose one...)");

        # Get selection
        my $n;
        loop {
            $n = val get;
            last if $n ~~ Int && $n ~~ 1..5;
            say "Invalid input; try again.";
        }

        given $n {
            when '1' { self.re-say.( "write email to " ~ $!dataset<Email> ); }
            when '2' { self.re-say.( "message by phone " ~ $!dataset<Phone> ); }
            when '3' { self.re-say.( "phone call " ~ $!dataset<Phone> ); }
            when '4' { self.re-say.( "discord message to " ~ $!dataset<DiscordHandle> ); }
        }

        # Goto Exit state or stay
        return $n < 5 ?? 'ActOnItem' !! 'Exit';
    }

    #--------------------------------------------------------
    method init-dataset() {
        self.dataset = get-address-book();
        self.initDataset = get-address-book();
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