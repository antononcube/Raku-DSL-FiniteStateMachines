#!/usr/bin/env perl6

use DSL::FiniteStateMachines::DataObtainer;

#--------------------------------------------------------
# Create FSM object
#--------------------------------------------------------

my DSL::FiniteStateMachines::DataObtainer $doFSM .= new;

$doFSM.make-machine;

#--------------------------------------------------------
# Adjust interaction and logging functions
#--------------------------------------------------------

$doFSM.re-say = -> *@args { say |@args.map({ '⚙️' ~ $_.Str.subst(:g, "\n", "\n⚙️") }) };
$doFSM.ECHOLOGGING = -> *@args {};

#--------------------------------------------------------
# Run FSM
#--------------------------------------------------------

# Run the FSM interactively
#$doFSM.run('WaitForRequest');

# Run the FSM with a list of commands
$doFSM.run('WaitForRequest',
        ["show summary", "", "group by Rows; show counts", "", "start over", "take last twelve", "", "second", "", "", "5", "", "quit"]);

# Show acquired data
if $doFSM.acquiredData ~~ Array  {
    #say to-pretty-table($doFSM.acquiredData);
    .say for $doFSM.acquiredData;
}