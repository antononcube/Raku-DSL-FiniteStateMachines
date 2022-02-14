#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use DSL::FiniteStateMachines::AddressBookCaller;

#--------------------------------------------------------
# Create FSM object
#--------------------------------------------------------

my DSL::FiniteStateMachines::AddressBookCaller $abcFSM .= new;

$abcFSM.make-machine;

#--------------------------------------------------------
# Adjust interaction and logging functions
#--------------------------------------------------------

$abcFSM.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️" )}) };
$abcFSM.ECHOLOGGING = -> *@args {};

#--------------------------------------------------------
# Run FSM
#--------------------------------------------------------

#$abcFSM.run('WaitForRequest', ["show summary", "", "group by Position; show counts", "", "start over", "take last twelve", "", "quit"]);
$abcFSM.run('WaitForRequest');

#if $abcFSM.acquiredData ~~ Array {
#    say to-pretty-table($abcFSM.acquiredData);
#}