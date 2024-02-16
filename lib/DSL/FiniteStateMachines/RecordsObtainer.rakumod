
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


        self.delete-state("AcquireItem");


        self.add-state("AcquireRecords",-> $obj { say "🔊 ACQUIRE records: ", $obj.dataset; });

        self.add-transition("ListOfItems", "recordsObtained", "AcquireRecords");

        self.add-transition("AcquireRecords", "acquired", "ActOnItem");

        say self.states.keys;

        #--------------------------------------------------------
        # Loggers
        #--------------------------------------------------------

        self.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
        self.ECHOLOGGING = -> *@args {};

        return self;
    }
}