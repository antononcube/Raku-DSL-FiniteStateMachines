#!/usr/bin/env perl6

use lib './lib';
use lib '.';


use DSL::FiniteStateMachines::AddressBookCaller::AddressBookGrammar;
use DSL::FiniteStateMachines::AddressBookCaller::AddressBookActions;
use DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand;

my @commands = (
'call an actor from X-Men',
'get Liv on the phone',
);
my $pres =
        DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand.parse(
                @commands[0],
                rule => 'call-command',
                actions => DSL::FiniteStateMachines::AddressBookCaller::AddressBookActions.new);

say $pres;

say $pres.made;
