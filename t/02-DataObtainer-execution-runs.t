use lib './lib';
use lib '.';
use silently;
use DSL::FiniteStateMachines::DataObtainer;
use Data::ExampleDatasets;
use Test;

##===========================================================
## Data Acquisition FSM
##===========================================================

my DSL::FiniteStateMachines::DataObtainer $doFSM .= new;
$doFSM.make-machine;

plan 8;

##-----------------------------------------------------------
## 1
my $inputs1 = ["show summary", "", "take top 8", "", "quit"];

ok { silently { $doFSM.run('WaitForRequest', $inputs1) } },
        "run-show-summary-take-top-8-quit";
## 2
silently { $doFSM.run('WaitForRequest', $inputs1) };

is-deeply $doFSM.dataset.elems, 8,
        "show-summary-take-top-8-quit";

##-----------------------------------------------------------
## 3
my $inputs2 = ["show summary", "", "take top five", "", "take the last one", "", ""];

ok { silently { $doFSM.run('WaitForRequest', $inputs2) } },
        "run-show-summary-take-top-5-take-the-last-one";

## 4
$doFSM.dataset = get-datasets-metadata(deepcopy=>True);

silently { $doFSM.run('WaitForRequest', $inputs2) };

is-deeply $doFSM.acquiredData, example-dataset( / 'AER::BondYield' $/),
        "show-summary-take-top-5-take-the-last-one";

##-----------------------------------------------------------
## 5
my $inputs3 = ["filter by 'Title' starts with 'Air'", "", "show summary", "", "take the last one", "", ""];

ok { silently { $doFSM.run('WaitForRequest', $inputs3) } },
        "run-texmex-winter";

## 6
$doFSM.dataset = get-datasets-metadata(deepcopy=>True);

silently { $doFSM.run('WaitForRequest', $inputs3) };

is-deeply $doFSM.acquiredData, example-dataset( / 'texmex::winter' $/),
        "texmex-winter";

##-----------------------------------------------------------
## 7
my $inputs4 = ["show summary", "", "group by Rows; show counts", "", "start over", "take last twelve", "", "quit"];

ok { silently { $doFSM.run('WaitForRequest', $inputs4) } },
        "run-group-by-counts";

## 8
$doFSM.dataset = get-datasets-metadata(deepcopy=>True);

silently { $doFSM.run('WaitForRequest', $inputs4) };

is-deeply $doFSM.dataset.elems, 12,
        "group-by-counts";

done-testing;
