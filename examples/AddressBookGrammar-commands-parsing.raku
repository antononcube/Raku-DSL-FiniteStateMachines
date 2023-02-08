#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use DSL::FiniteStateMachines::AddressBookCaller::AddressBookGrammar;
use DSL::FiniteStateMachines::AddressBookCaller::AddressBookActions;
use DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand;

use DSL::Entity::AddressBook;
use DSL::Entity::AddressBook::ResourceAccess;

my $ACTOBJ = DSL::FiniteStateMachines::AddressBookCaller::AddressBookActions.new(resources => DSL::Entity::AddressBook::resource-access-object());

my @commands = (
'call an actor from X-Men',
'get Liv on the phone',
);
my $pres =
        DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand.parse(
                @commands[0],
                rule => 'call-command',
                actions => $ACTOBJ,
                args => (DSL::Entity::AddressBook::resource-access-object(),));

say $pres;

say $pres.made;
