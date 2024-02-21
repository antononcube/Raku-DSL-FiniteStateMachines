
use DSL::FiniteStateMachines::QueryRetrieveActFSMRole;
use DSL::FiniteStateMachines::RecordsObtainer::FSMGlobalCommand;
use DSL::FiniteStateMachines::DataObtainer;
use Data::ExampleDatasets;
use Data::Reshapers;
use Data::TypeSystem::Predicates;

use Text::CSV;
use XDG::BaseDirectory :terms;

#===========================================================
# RecordsObtainer
#===========================================================

class DSL::FiniteStateMachines::RecordsObtainer
        is DSL::FiniteStateMachines::DataObtainer {

    #--------------------------------------------------------
    # Metadata dataset predicate
    method is-metadata-row( $data ) {
        return $data ~~ Hash && ($data.keys (&) self.datasetColumnNames).elems == self.datasetColumnNames.elems;
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'PrioritizedList',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions);

        &.re-say.(to-pretty-table($.dataset.pick(12), field-names => self.datasetColumnNames));

        # return 'WaitForRequest';
        return self.transition-target(@transitions, 'priorityListGiven');
    }

    #--------------------------------------------------------
    multi method choose-transition(Str $stateID where $_ ~~ 'AcquireRecords',
                                   $input is copy = Whatever, UInt $maxLoops = 5 --> Str) {

        # Get next transitions
        my DSL::FiniteStateMachines::Transition @transitions = %.states{$stateID}.explicitNext;

        &.ECHOLOGGING.(@transitions.raku.Str);

        self.acquiredData = self.dataset.clone;

        # return 'ActOnItem';
        return self.transition-target(@transitions, 'acquired');
    }

    #--------------------------------------------------------
    method apply-query-retrieve-act-pattern() {

        #--------------------------------------------------------
        # States
        #--------------------------------------------------------
        self.add-state("WaitForRequest",   -> $obj { say "🔊 PLEASE enter item request."; });
        self.add-state("ListOfItems",      -> $obj { say "🔊 LISTING items."; });
        self.add-state("PrioritizedList",  -> $obj { say "🔊 PRIORITIZED items."; });
        self.add-state("ExportRecords",    -> $obj { say "🔊 EXPORT records: ", $obj.dataset; });
        self.add-state("ActOnItem",        -> $obj { say "🔊 ACT ON items: ", $obj.dataset.elems; });
        self.add-state("Help",             -> $obj { say "🔊 HELP is help..."; });
        self.add-state("Exit",             -> $obj { say "🔊 SHUTTING down..."; });

        #--------------------------------------------------------
        # Transitions
        #--------------------------------------------------------
        self.add-transition("WaitForRequest",   "itemSpec",           "ListOfItems");
        self.add-transition("WaitForRequest",   "startOver",          "WaitForRequest");
        self.add-transition("WaitForRequest",   "prioritize",         "PrioritizedList");
        self.add-transition("WaitForRequest",   "saveData",           "ExportRecords");
        self.add-transition("WaitForRequest",   "help",               "Help");
        self.add-transition("WaitForRequest",   "quit",               "Exit");

        self.add-transition("PrioritizedList",  "priorityListGiven",  "WaitForRequest");

        self.add-transition("ListOfItems",      "manyItems",          "WaitForRequest");
        self.add-transition("ListOfItems",      "uniqueItemObtained", "WaitForRequest");
        self.add-transition("ListOfItems",      "noItems",            "WaitForRequest");
        self.add-transition("ListOfItems",      "noChange",           "WaitForRequest");

        self.add-transition("ExportRecords",    "acquired",           "ActOnItem");
        self.add-transition("ActOnItem",        "stay",               "ActOnItem");
        self.add-transition("ActOnItem",        "quit",               "Exit");

        self.add-transition("Help",             "helpGiven",          "WaitForRequest");

        # Result
        return self;
    }

    #--------------------------------------------------------
    method init-dataset(@dataset) {
        if !is-array-of-hashes(@dataset) {
            die "The first argument is expected to be an array of hashes.";
        }
        self.dataset = @dataset.clone>>.clone;
        self.initDataset = self.dataset;
        self.datasetColumnNames = self.dataset.head.keys.Array;
    }

    #--------------------------------------------------------
    method make-machine(@dataset) {
        # Initialize attributes
        self.FSMGrammar = DSL::FiniteStateMachines::RecordsObtainer::FSMGlobalCommand;
        self.init-dataset(@dataset);

        #--------------------------------------------------------
        # States and transitions
        #--------------------------------------------------------
        self.apply-query-retrieve-act-pattern();

        #--------------------------------------------------------
        # Loggers
        #--------------------------------------------------------

        self.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
        self.ECHOLOGGING = -> *@args {};

        return self;
    }
}