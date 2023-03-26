
use DSL::FiniteStateMachines::QueryRetrieveActFSMRole;
use DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand;
use DSL::FiniteStateMachines::DataObtainer::FSMGlobalCommand;
use DSL::FiniteStateMachines::AddressBookCaller::Utilities;
use DSL::FiniteStateMachines::AddressBookCaller::AddressBookGrammar;
use DSL::FiniteStateMachines::AddressBookCaller::AddressBookActions;
use Data::Reshapers;
use silently;

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
    multi method choose-transition(Str $stateID where $_ ~~ 'WaitForCallCommand',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        # Get input if not given
        if $input.isa(Whatever) {
            $input = val get;
        }
        &.re-say.("Input: ", $input.raku.Str);

        # Check was "global" command was entered. E.g."start over".
        my $translator = DSL::FiniteStateMachines::AddressBookCaller::AddressBookActions.new(object => self.dataset.clone);

        my $pres;
        silently {
            $pres = DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand.parse($input, rule => 'TOP', actions => $translator, args => self.grammar-args);
        }

        &.ECHOLOGGING.("$stateID: Call commad parsing result: ", $pres);

        # say $pres<call-command>;

        if $pres<call-command> {
            my $translatedInput = $pres.made;

            self.re-say.("Translated input: ", $translatedInput);

            return self.choose-transition( self.transition-target(@transitions, 'translated'), $translatedInput, :$maxLoops)
        }

        return self.choose-transition( self.transition-target(@transitions, 'unchanged'), $input, :$maxLoops)
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'PrioritizedList',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions);

        &.re-say.(to-pretty-table($.dataset.pick(12)), field-names => self.datasetColumnNames);

        # return 'WaitForRequest';
        return self.transition-target(@transitions, 'priorityListGiven');
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'AcquireItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        # The parser/ actions <list-management-command> might produce a table with one row
        # or just the hash corresponding to that row.
        # If the former take the content of the table.
        if self.dataset ~~ Array {
            self.dataset = self.dataset.values[0];
        }

        &.re-say.("Acquiring contact info for : ", self.dataset<Name>);

        # return 'ActOnItem';
        return self.transition-target(@transitions, 'acquired');
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ActOnItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        # Prompt selection menu
        self.re-say.( "[1] email, [2] phone message, [3] phone call, [4] discord message, or [5] nothing\n(choose one...)");

        # Get selection
        my $n;
        if $input.isa(Whatever) {
            loop {
                $n = val get;
                last if +$n ~~ Int && +$n ~~ 1..5;
                say "Invalid input; try again.";
            }
        } else {
            $n = $input;
            say "Invalid input $input"
            unless +$n ~~ Int && +$n ~~ 1..5;
        }
        self.re-say.("Input: ", $input.raku.Str);

        $n = $n.Int;
        given $n {
            when 1 { self.re-say.( "write email to "     ~ self.dataset<Email> ); }
            when 2 { self.re-say.( "message by phone "   ~ self.dataset<Phone> ); }
            when 3 { self.re-say.( "phone call "         ~ self.dataset<Phone> ); }
            when 4 { self.re-say.( "discord message to " ~ self.dataset<DiscordHandle> ); }
            default { self.re-say.('do nothing'); }
        }

        # Goto Exit state or stay
        # return $n < 5 ?? 'ActOnItem' !! 'Exit';
        return self.transition-target( @transitions, $n < 5 ?? 'stay' !! 'quit');
    }

    #--------------------------------------------------------
    method init-dataset() {
        self.dataset = get-address-book();
        self.initDataset = get-address-book();
    }

    #--------------------------------------------------------
    method make-machine(@grammar-args = ()) {
        # Initialize attributes
        self.FSMGrammar = DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand;
        self.grammar-args = @grammar-args;
        self.init-dataset();

        self.apply-query-retrieve-act-pattern();

        #--------------------------------------------------------
        # States
        #--------------------------------------------------------
        self.add-state("WaitForCallCommand", -> $obj { say "🔊 PLEASE enter call request."; });
        self.add-state("WaitForRequest",     -> $obj { say "🔊 PLEASE enter item request."; });
        self.add-state("ListOfItems",        -> $obj { say "🔊 LISTING items."; });
        self.add-state("PrioritizedList",    -> $obj { say "🔊 PRIORITIZED items."; });
        self.add-state("AcquireItem",        -> $obj { say "🔊 ACQUIRE item: ", $obj.dataset[0]; });
        self.add-state("ActOnItem",          -> $obj { say "🔊 ACT ON item: ", $obj.dataset[0]; });
        self.add-state("Help",               -> $obj { say "🔊 HELP is help..."; });
        self.add-state("Exit",               -> $obj { say "🔊 SHUTTING down..."; });

        #--------------------------------------------------------
        # Transitions
        #--------------------------------------------------------
        self.add-transition("WaitForCallCommand", "translated",         "WaitForRequest");
        self.add-transition("WaitForCallCommand", "unchanged",          "WaitForRequest");

        self.add-transition("WaitForRequest",     "itemSpec",           "ListOfItems");
        self.add-transition("WaitForRequest",     "startOver",          "WaitForRequest");
        self.add-transition("WaitForRequest",     "prioritize",         "PrioritizedList");
        self.add-transition("WaitForRequest",     "help",               "Help");
        self.add-transition("WaitForRequest",     "quit",               "Exit");

        self.add-transition("PrioritizedList",    "priorityListGiven",  "WaitForCallCommand");

        self.add-transition("ListOfItems",        "manyItems",          "WaitForCallCommand");
        self.add-transition("ListOfItems",        "noItems",            "WaitForCallCommand");
        self.add-transition("ListOfItems",        "noChange",           "WaitForCallCommand");
        self.add-transition("ListOfItems",        "uniqueItemObtained", "AcquireItem");

        self.add-transition("AcquireItem",        "acquired",           "ActOnItem");
        self.add-transition("ActOnItem",          "stay",               "ActOnItem");
        self.add-transition("ActOnItem",          "quit",               "Exit");

        self.add-transition("Help",               "helpGiven",          "WaitForCallCommand");

        
        #--------------------------------------------------------
        # Loggers
        #--------------------------------------------------------

        self.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
        self.ECHOLOGGING = -> *@args {};

        return self;
    }
}