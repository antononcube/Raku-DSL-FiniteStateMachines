#!/usr/bin/env perl6

use Data::ExampleDatasets;
use DSL::FiniteStateMachines::RecordsObtainer;
use Data::TypeSystem;
use Data::TypeSystem::Predicates;

#--------------------------------------------------------
# Example dataset
#--------------------------------------------------------

my @dsData = example-dataset( / 'COUNT::titanic' $/ ):keep;

note deduce-type(@dsData);
note is-array-of-hashes(@dsData);

.say for @dsData.pick(10);

say '=' x 120;

#--------------------------------------------------------
# Create FSM object
#--------------------------------------------------------

my DSL::FiniteStateMachines::RecordsObtainer $doFSM .= new;

$doFSM.make-machine(@dsData);

say $doFSM.to-wl();

say '=' x 120;

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
        ["show summary", "", "group by sex; show counts", "", "start over", "take last twelve", "", "export data", "", "5", "", "quit"]);

#--------------------------------------------------------
# Acquired data
#--------------------------------------------------------
say '=' x 120;
say 'Actqured data';
say '-' x 120;

# Show acquired data
if $doFSM.acquiredData ~~ Array  {
    #say to-pretty-table($doFSM.acquiredData);
    .say for $doFSM.acquiredData;
}