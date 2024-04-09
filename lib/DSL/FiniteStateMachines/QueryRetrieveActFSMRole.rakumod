
use Data::Reshapers;
use Data::Summarizers;
use Data::ExampleDatasets;

use DSL::FiniteStateMachines::FSMish;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::Shared::Roles::English::ListManagementCommand;

use DSL::English::DataQueryWorkflows::Grammar;
use DSL::English::DataQueryWorkflows::Actions::Raku::Reshapers;
use Lingua::NumericWordForms::Roles::English::WordedNumberSpec;

constant $MAX-ROWS-TO-SHOW = 20;

#--------------------------------------------------------
role DSL::FiniteStateMachines::QueryRetrieveActFSMRole
        does DSL::FiniteStateMachines::FSMish {

    #--------------------------------------------------------
    # This dataset is supposed to be handled by the functions Data::Reshapers
    has $.dataset is rw;
    has $.datasetColumnNames is rw = Whatever;
    has $.initDataset is rw;
    has $.acquiredData;
    has $.itemSpec is rw;
    has $.itemSpecCommand is rw;
    has $.FSMGrammar is rw;
    has @.grammar-args is rw = ();
    has $.FSMActions is rw;

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
    method command-transition-target($stateID, $input, @transitions, $pres) {
        if $pres<global-command><global-quit> {

            &.re-say.("$stateID: Quiting.");

            # return 'Exit';
            return self.transition-target(@transitions, 'quit');

        } elsif $pres<global-command><global-cancel> {

            &.re-say.("$stateID: Starting over.");

            $!dataset = $!initDataset.clone;

            # return 'WaitForRequest';
            return self.transition-target(@transitions, 'startOver');

        } elsif $pres<global-command><global-show-all> {

            $!dataset = $!initDataset.clone;
            $!itemSpec = $pres;
            $!itemSpecCommand = $input;

            # return 'ListOfItems';
            return self.transition-target(@transitions, 'itemSpec');

        } elsif $pres<global-command><global-help> {

            &.re-say.("$stateID: Help.");
            &.re-say.("$stateID: Type commands for the FSM...");

            # return 'WaitForRequest';
            return self.transition-target(@transitions, 'help');

        } elsif $pres<global-command><global-priority-list> {

            # return 'PriorityList';
            return self.transition-target(@transitions, 'prioritize');

        } elsif $pres<global-command><global-save-data> {

            # return 'PriorityList';
            return self.transition-target(@transitions, 'saveData');

        } elsif $pres<global-command><global-repeat-last> {

            # return 'RepeatLast';
            return self.transition-target(@transitions, 'repeatLast');

        } elsif so $pres<global-command> {

            $.re-warn.("$stateID: No implemented reaction for the given global command input.");

            # return 'WaitForRequest';
            return self.transition-target(@transitions, 'startOver');

        }

        return Nil;
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'WaitForRequest',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        # Get input if not given
        if $input.isa(Whatever) {
            $input = val get;
        }

        # Check whether a "global" command was entered. E.g."start over".

        my $manager = do if $.FSMActions.DEFINITE {
            $.FSMActions
        } else {
            $.FSMActions.new(object => $!dataset.clone);
        }

        my $pres = $.FSMGrammar.parse($input, rule => 'TOP', actions => $manager, args => self.grammar-args);

        # Here we handle <global-command> only, but descendant classes can do other handling
        my $comRes = self.command-transition-target($stateID, $input, @transitions, $pres);
        with $comRes {
            &.ECHOLOGGING.("$stateID: Global commad parsing result: ", $pres);
            return $comRes;
        }

        &.ECHOLOGGING.("$stateID: Main command parsing result: ", $pres);

        # Register the input command and the parsing result
        $!itemSpecCommand = $input;
        $!itemSpec = $pres;

        # If it cannot be parsed, show message
        # Maybe ...

        if not so $pres {
            # return 'UnknownCommand';
            return self.transition-target(@transitions, 'unparsed');
        }

        # return 'ListOfItems';
        return self.transition-target(@transitions, 'itemSpec');
    }

    #--------------------------------------------------------
    method execute-data-processing() {
        use MONKEY;
        my $obj = $!dataset;
        my $code = $!itemSpec ~~ Match ?? $!itemSpec.made !! $!itemSpec;
        &.ECHOLOGGING.("Interpreted: ⎡$code⎦");

        try {
            EVAL $code;
        }

        if $! {
            note 'Evaluation error. Pipeline value is not changed.'
        } else {
            $!dataset = $obj;
            if $!dataset ~~ Seq { $!dataset = $!dataset.Array }
        }
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ListOfItems',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);
        &.ECHOLOGGING.("$stateID: itemSpec => $!itemSpec");

        if $!itemSpec<global-command><global-show-all> {

            &.re-say.(to-pretty-table($!dataset, field-names => self.datasetColumnNames));
            # return "WaitForRequest";
            return self.transition-target(@transitions, 'noChange');

        }

        my $lastDataset = $!dataset.clone;

        # Get new dataset
        &.ECHOLOGGING.("Parsed: {$!itemSpec.gist}");
        #if $!itemSpec<list-management-command> || $!itemSpec<workflow-commands-list> {
        if ! $!itemSpec<global-command> {

            self.execute-data-processing();
        }

        if $lastDataset eqv $!dataset {
            &.re-say.("$stateID: Pipeline value was not changed.");
            # return 'WaitForRequest';
            return self.transition-target(@transitions, 'noChange');
        }

        #`(
        say '$!dataset : ', $!dataset.raku;
        say 'self.is-metadata-row($!dataset) : ', self.is-metadata-row($!dataset);
        say 'self.is-metadata-dataset($!dataset) : ', self.is-metadata-dataset($!dataset);
        )
        if self.is-metadata-row($!dataset) {
            &.re-say.("$stateID: Obtained:");
            &.re-say.(to-pretty-table([$!dataset,], field-names => self.datasetColumnNames))
        } elsif self.is-metadata-dataset($!dataset) {
            if $!dataset.elems ≤ $MAX-ROWS-TO-SHOW {
                &.re-say.("$stateID: Obtained {$!dataset.elems } records:");
                &.re-say.(to-pretty-table($!dataset, field-names => self.datasetColumnNames));
            } else {
                &.re-say.("$stateID: Obtained {$!dataset.elems } records. Here are the first $MAX-ROWS-TO-SHOW");
                &.re-say.(to-pretty-table($!dataset.head($MAX-ROWS-TO-SHOW), field-names => self.datasetColumnNames));
            }
        }

        if $!dataset.elems == 0 {
            # No items
            &.re-say.("Empty set was obtained. Reverting to previous value.");
            $!dataset = $lastDataset;

            # return 'WaitForRequest';
            return self.transition-target(@transitions, 'noItems');

        } elsif self.is-metadata-row($!dataset) || self.is-metadata-dataset($!dataset) && $!dataset.elems == 1 {
            # One item

            # return 'AcquireItem';
            return self.transition-target(@transitions, 'uniqueItemObtained');

        } else {
            # Many items

            # return 'WaitForRequest';
            return self.transition-target(@transitions, 'manyItems');
        }

        # If anything else fails
        # return 'WaitForRequest';
        return self.transition-target(@transitions, 'noChange');
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'UnknownCommand',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        # Prompt selection menu
        &.re-say.('Unknown command');

        note 'Unknown command';

        # Goto Exit state or stay
        return self.transition-target(@transitions, 'continue');;
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'RepeatLast',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        # Prompt selection menu
        &.re-say.('Repeating last answer:');
        &.re-say.(to-pretty-table($!dataset, field-names => self.datasetColumnNames));

        # Goto Exit state or stay
        return self.transition-target(@transitions, 'continue');;
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'PrioritizedList',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        note 'Not overridden';

        return 'WaitForRequest';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'ExportRecords',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {
        # Prompt selection menu
        &.re-say.('Nothing to do...');

        note 'Not overridden';

        # Goto Exit state or stay
        return 'Exit';
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'AcquireItem',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

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
        return 'WaitForRequest';
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
        self.add-state("UnknownCommand",   -> $obj { say "🔊 UNKNOWN COMMAND."; });
        self.add-state("RepeatLast",       -> $obj { say "🔊 REPEAT last result."; });
        self.add-state("ExportRecords",    -> $obj { say "🔊 EXPORT records: ", $obj.dataset; });
        self.add-state("AcquireItem",      -> $obj { say "🔊 ACQUIRE item: ", $obj.dataset[0]; });
        self.add-state("ActOnItem",        -> $obj { say "🔊 ACT ON item: ", $obj.dataset[0]; });
        self.add-state("Help",             -> $obj { say "🔊 HELP is help..."; });
        self.add-state("Exit",             -> $obj { say "🔊 SHUTTING down..."; });

        #--------------------------------------------------------
        # Transitions
        #--------------------------------------------------------
        self.add-transition("WaitForRequest",   "itemSpec",           "ListOfItems");
        self.add-transition("WaitForRequest",   "startOver",          "WaitForRequest");
        self.add-transition("WaitForRequest",   "prioritize",         "PrioritizedList");
        self.add-transition("WaitForRequest",   "saveData",           "ExportRecords");
        self.add-transition("WaitForRequest",   "repeatLast",         "RepeatLast");
        self.add-transition("WaitForRequest",   "unparsed",           "UnknownCommand");
        self.add-transition("WaitForRequest",   "help",               "Help");
        self.add-transition("WaitForRequest",   "quit",               "Exit");

        self.add-transition("PrioritizedList",  "priorityListGiven",  "WaitForRequest");
        self.add-transition("UnknownCommand",   "continue",           "WaitForRequest");
        self.add-transition("RepeatLast",       "continue",           "WaitForRequest");

        self.add-transition("ListOfItems",      "manyItems",          "WaitForRequest");
        self.add-transition("ListOfItems",      "noItems",            "WaitForRequest");
        self.add-transition("ListOfItems",      "noChange",           "WaitForRequest");
        self.add-transition("ListOfItems",      "uniqueItemObtained", "AcquireItem");

        self.add-transition("ExportRecords",    "acquired",           "ActOnItem");
        self.add-transition("AcquireItem",      "acquired",           "ActOnItem");
        self.add-transition("ActOnItem",        "stay",               "ActOnItem");
        self.add-transition("ActOnItem",        "quit",               "Exit");

        self.add-transition("Help",             "helpGiven",          "WaitForRequest");

        # Result
        return self;
    }

}