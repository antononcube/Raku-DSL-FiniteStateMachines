

use Lingua::NumericWordForms::Roles::English::WordedNumberSpec;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::English::DataQueryWorkflows::Grammar;

#--------------------------------------------------------
# FSM global command grammar
grammar DSL::FiniteStateMachines::DataObtainer::FSMGlobalCommand
        is DSL::English::DataQueryWorkflows::Grammar
        does Lingua::NumericWordForms::Roles::English::WordedNumberSpec
        does DSL::Shared::Roles::English::GlobalCommand {
    rule TOP { <.display-directive>? <list-management-command> || <global-command> || <workflow-commands-list> }
};