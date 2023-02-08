#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use DSL::FiniteStateMachines::AddressBookCaller;

use DSL::Entity::AddressBook;
use DSL::Entity::AddressBook::ResourceAccess;

my $resourceObj = DSL::Entity::AddressBook::resource-access-object();

#--------------------------------------------------------
# Create FSM object
#--------------------------------------------------------

my DSL::FiniteStateMachines::AddressBookCaller $abcFSM .= new;

$abcFSM.make-machine(($resourceObj,));

#--------------------------------------------------------
# Adjust interaction and logging functions
#--------------------------------------------------------

$abcFSM.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
$abcFSM.ECHOLOGGING = -> *@args {};

# say $abcFSM.to-wl();

#--------------------------------------------------------
# Run FSM
#--------------------------------------------------------

$abcFSM.run('WaitForCallCommand', ["call an actor from LOTR", "", "take last three", "", "quit"]);
#$abcFSM.run('WaitForCallCommand');

#if $abcFSM.acquiredData ~~ Array {
#    say to-pretty-table($abcFSM.acquiredData);
#}