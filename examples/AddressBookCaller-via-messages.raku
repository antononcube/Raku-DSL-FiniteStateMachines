#!/usr/bin/env perl6

use lib <. /lib>;

use DSL::FiniteStateMachines::AddressBookCaller;
use DSL::FiniteStateMachines::FSMMessaging;

use DSL::Entity::AddressBook;
use DSL::Entity::AddressBook::ResourceAccess;

my $resourceObj = DSL::Entity::AddressBook::resource-access-object();

#--------------------------------------------------------
# Create FSM object
#--------------------------------------------------------

#my DSL::FiniteStateMachines::AddressBookCaller $abcFSM .= new;
my $abcFSM = DSL::FiniteStateMachines::AddressBookCaller.new() but DSL::FiniteStateMachines::FSMMessaging;

$abcFSM.make-machine(($resourceObj,));

say $abcFSM.to-mermaid-js;

say '📇📞' x 30;

#--------------------------------------------------------
# Adjust interaction and logging functions
#--------------------------------------------------------

$abcFSM.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
$abcFSM.ECHOLOGGING = -> *@args {};

$abcFSM.ECHOLOGGING = &say;

#--------------------------------------------------------
# Run FSM
#--------------------------------------------------------

$abcFSM.init-message-run('WaitForCallCommand');
say (currentStateID => $abcFSM.currentStateID);

$abcFSM.message-run( "call an actor from LOTR");
say (currentStateID => $abcFSM.currentStateID);

$abcFSM.message-run("take last three");
say (currentStateID => $abcFSM.currentStateID);

$abcFSM.message-run("take the second");
say (currentStateID => $abcFSM.currentStateID);

$abcFSM.message-run("2");
$abcFSM.message-run("2");
$abcFSM.message-run("2");

$abcFSM.message-run("quit");