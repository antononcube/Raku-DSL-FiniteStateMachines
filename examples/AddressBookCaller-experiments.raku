#!/usr/bin/env perl6

use DSL::FiniteStateMachines::AddressBookCaller;

use DSL::Entity::AddressBook;
use DSL::Entity::AddressBook::ResourceAccess;

my $resourceObj = DSL::Entity::AddressBook::resource-access-object();

#--------------------------------------------------------
# Create FSM object
#--------------------------------------------------------

my DSL::FiniteStateMachines::AddressBookCaller $abcFSM .= new;

$abcFSM.make-machine(($resourceObj,));

# Show dataset sample
#.say for $abcFSM.dataset.head(3);

#--------------------------------------------------------
# Adjust interaction and logging functions
#--------------------------------------------------------

#$abcFSM.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
#$abcFSM.ECHOLOGGING = -> *@args {};

#$abcFSM.ECHOLOGGING = &say;

# say $abcFSM.to-wl();

#--------------------------------------------------------
# Run FSM
#--------------------------------------------------------

# Run the FSM interactively
#$abcFSM.run('WaitForCallCommand');

# Run the FSM with a list of commands:
#$abcFSM.run('WaitForCallCommand', ["call an actor from LOTR", "", "take last three", "", "quit"]);
$abcFSM.run('WaitForCallCommand', ["call an actor from LOTR", "", "take last three", "", "take the second", "", "", "2", "5", "", "quit"]);