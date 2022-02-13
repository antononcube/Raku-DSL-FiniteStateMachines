#!/usr/bin/env perl6

use lib './lib';
use lib '.';

use DSL::FiniteStateMachines::FSMish;

class DSL::FiniteStateMachines::SimpleFSM does DSL::FiniteStateMachines::FSMish {}

#===== Usage example: Console-based vending machine =====#
# Initial version part taken from:
# https://rosettacode.org/wiki/Finite_state_machine#Raku

#`(
my DSL::Shared::FiniteStateMachines::CoreFSM $machine .= new;

$machine.add-state("ready",     { say "Please deposit coins.";                     });
$machine.add-state("waiting",   { say "Please select a product.";                  });
$machine.add-state("dispense",  { sleep 2; say "Please remove product from tray."; });
$machine.add-state("refunding", { sleep 1; say "Refunding money...";               });
$machine.add-state("exit",      { say "Shutting down...";                          });

$machine.add-transition("ready",     "quit",    "exit");
$machine.add-transition("ready",     "deposit", "waiting");
$machine.add-transition("waiting",   "select",  "dispense");
$machine.add-transition("waiting",   "refund",  "refunding");
$machine.add-transition("dispense",  "remove",  "ready");
$machine.add-transition("refunding",            "ready");

$machine.run("ready");
)

#===== Usage example: vending machine by sequence =====#
# Initial version part taken from:
# https://rosettacode.org/wiki/Finite_state_machine#Raku

my DSL::FiniteStateMachines::SimpleFSM $testFSM .= new;

$testFSM.add-state("ready",      -> $obj { say "🔊 PLEASE deposit coins."; });
$testFSM.add-state("waiting",    -> $obj { say "🔊 PLEASE select a product."; });
$testFSM.add-state("dispense",   -> $obj { say "🔊 PLEASE remove product from tray."; });
$testFSM.add-state("refunding",  -> $obj { say "🔊 REFUNDING money..."; });
$testFSM.add-state("exit",       -> $obj { say "🔊 SHUTTING down..."; });
$testFSM.add-state("disconnect", -> $obj { say "🔊 Disconnecting..."; });
$testFSM.add-state("switchoff",  -> $obj { say "🔊 Switch off..."; });

$testFSM.add-transition("ready",     "quit",    "exit");
$testFSM.add-transition("ready",     "deposit", "waiting");
$testFSM.add-transition("waiting",   "select",  "dispense");
$testFSM.add-transition("waiting",   "refund",  "refunding");
$testFSM.add-transition("dispense",  "remove",  "ready");
$testFSM.add-transition("refunding",            "ready");
$testFSM.add-transition("exit",                 "disconnect");
$testFSM.add-transition("disconnect",           "switchoff");

# say $testFSM.states.gist;

$testFSM.ECHOLOGGING = sub (|) {};
$testFSM.run("ready", [2,1,1,1]);
#$testFSM.run("ready", [2,2,1,1,1]);