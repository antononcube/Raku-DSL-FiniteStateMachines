use lib './lib';
use lib '.';

use DSL::FiniteStateMachines::FSMish;

##===========================================================
## Vending machine FSM
##===========================================================

class DSL::FiniteStateMachines::SimpleFSM does DSL::FiniteStateMachines::FSMish {}

my DSL::FiniteStateMachines::SimpleFSM $testFSM .= new;

my Str $FSMNotes = "";
sub acc-say(*@args) { $FSMNotes ~= "\n" ~ @args.join(' ') };

$testFSM.add-state("ready", -> $obj { acc-say "🔊 PLEASE deposit coins."; });
$testFSM.add-state("waiting", -> $obj { acc-say "🔊 PLEASE select a product."; });
$testFSM.add-state("dispense", -> $obj { acc-say "🔊 PLEASE remove product from tray."; });
$testFSM.add-state("refunding", -> $obj { acc-say "🔊 REFUNDING money..."; });
$testFSM.add-state("exit", -> $obj { acc-say "🔊 SHUTTING down..."; });
$testFSM.add-state("disconnect", -> $obj { acc-say "🔊 Disconnecting..."; });
$testFSM.add-state("switchoff", -> $obj { acc-say "🔊 Switch off..."; });

$testFSM.add-transition("ready", "quit", "exit");
$testFSM.add-transition("ready", "deposit", "waiting");
$testFSM.add-transition("waiting", "select", "dispense");
$testFSM.add-transition("waiting", "refund", "refunding");
$testFSM.add-transition("dispense", "remove", "ready");
$testFSM.add-transition("refunding", "ready");
$testFSM.add-transition("exit", "disconnect");
$testFSM.add-transition("disconnect", "switchoff");


##===========================================================
## Tests
##===========================================================

use Test;

plan 2;

##-----------------------------------------------------------
## Structure
##-----------------------------------------------------------

## 1
isa-ok $testFSM,
        DSL::FiniteStateMachines::SimpleFSM,
        'Simle FSM object';

##-----------------------------------------------------------
## Sequence run
##-----------------------------------------------------------

## 2
$testFSM.ECHOLOGGING = sub (|) {};
$testFSM.re-say = &acc-say;

$testFSM.run("ready", [2, 1, 1, 1]);

like $FSMNotes,
        / .*
        '🔊 PLEASE deposit coins' .*
        '🔊 PLEASE select a product' .*
        '🔊 PLEASE remove product from tray' .*
        '🔊 PLEASE deposit coins' .*
        '🔊 SHUTTING down' .*
        '🔊 Disconnecting' .*
        '🔊 Switch off' .*/,
        'Core FSM trace';

done-testing;
