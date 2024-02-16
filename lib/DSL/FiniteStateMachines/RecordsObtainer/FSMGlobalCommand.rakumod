

use Lingua::NumericWordForms::Roles::English::WordedNumberSpec;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::English::DataQueryWorkflows::Grammar;

#--------------------------------------------------------
# FSM global command grammar
grammar DSL::FiniteStateMachines::RecordsObtainer::FSMGlobalCommand
        is DSL::English::DataQueryWorkflows::Grammar
        does Lingua::NumericWordForms::Roles::English::WordedNumberSpec
        does DSL::Shared::Roles::English::GlobalCommand {
    rule TOP { <global-command> || <.display-directive>? <list-management-command> || <workflow-commands-list> }
};