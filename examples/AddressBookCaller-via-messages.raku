#!/usr/bin/env perl6

use lib <. /lib>;

use DSL::FiniteStateMachines::AddressBookCaller;
use DSL::FiniteStateMachines::FSMReactish;

use DSL::Entity::AddressBook;
use DSL::Entity::AddressBook::ResourceAccess;

my $resourceObj = DSL::Entity::AddressBook::resource-access-object();

#--------------------------------------------------------
# Create FSM object
#--------------------------------------------------------

#my DSL::FiniteStateMachines::AddressBookCaller $abcFSM .= new;
my $abcFSM = DSL::FiniteStateMachines::AddressBookCaller.new() but DSL::FiniteStateMachines::FSMReactish;

$abcFSM.make-machine(($resourceObj,));

say $abcFSM.to-wl;

say '-' x 60;

say $abcFSM.to-mermaid-js;

say '📲' x 60;

#--------------------------------------------------------
# Adjust interaction and logging functions
#--------------------------------------------------------
#
#$abcFSM.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
#$abcFSM.ECHOLOGGING = -> *@args {};
#
#$abcFSM.ECHOLOGGING = &say;

#--------------------------------------------------------
# Run FSM
#--------------------------------------------------------

$abcFSM.react-ready-with('WaitForCallCommand');
say (currentStateID => $abcFSM.currentStateID);

$abcFSM.react-to( "call an actor from LOTR");
say 'after: "call an actor from LOTR"';
say (currentStateID => $abcFSM.currentStateID);

$abcFSM.react-to("take last three");
say 'after: "take last three"';
say (currentStateID => $abcFSM.currentStateID);

$abcFSM.react-to("take the second");
say 'after: "take the second"';
say (currentStateID => $abcFSM.currentStateID);

#`[
#$abcFSM.react-to("");
#$abcFSM.react-to("");
]

say $abcFSM.react-to("3");
say $abcFSM.react-to("5");

$abcFSM.react-to("quit");
