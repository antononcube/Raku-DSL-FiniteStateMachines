

use Lingua::NumericWordForms::Roles::English::WordedNumberSpec;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::English::DataQueryWorkflows::Grammar;
use DSL::FiniteStateMachines::AddressBookCaller::AddressBookGrammar;

#--------------------------------------------------------
# FSM global command grammar
grammar DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand
        is DSL::English::DataQueryWorkflows::Grammar
        does DSL::FiniteStateMachines::AddressBookCaller::AddressBookGrammar
        does Lingua::NumericWordForms::Roles::English::WordedNumberSpec
        does DSL::Shared::Roles::English::GlobalCommand {
    rule TOP { <call-command> || <.display-directive>? <list-management-command> || <global-command> || <workflow-commands-list> }
};