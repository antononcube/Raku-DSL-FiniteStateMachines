use v6.d;

use Lingua::NumericWordForms::Roles::English::WordedNumberSpec;
use DSL::Shared::Roles::English::GlobalCommand;
use DSL::English::DataQueryWorkflows::Grammar;
use DSL::FiniteStateMachines::AddressBookCaller::AddressBookGrammar;

use DSL::Shared::Entity::Grammar::EntityNames;
use DSL::Entity::AddressBook;
use DSL::Entity::AddressBook::ResourceAccess;
use DSL::Entity::AddressBook::Grammar::EntityNames;

#--------------------------------------------------------
# FSM global command grammar
grammar DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand
        is DSL::English::DataQueryWorkflows::Grammar
        does Lingua::NumericWordForms::Roles::English::WordedNumberSpec
        does DSL::FiniteStateMachines::AddressBookCaller::AddressBookGrammar
        does DSL::Shared::Roles::English::GlobalCommand
        does DSL::Shared::Entity::Grammar::EntityNames
        does DSL::Entity::AddressBook::Grammar::EntityNames {
    rule TOP($*resourceObj) { <call-command($*resourceObj)> || <.display-directive>? <list-management-command> || <global-command> || <workflow-commands-list> }
};