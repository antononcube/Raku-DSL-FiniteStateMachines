# Raku DSL::FiniteStateMachines
    
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## In brief

This repository is for a Raku package with class definitions and functions for 
creation of Finite State Machines (FSMs) and their execution.

-----

## Usage example (Address book)

Here we load the definition of the class `AddressBookCaller` (provided by this package)
and related entities package, 
["DSL::Entity::AddressBook"](https://github.com/antononcube/Raku-DSL-Entity-AddressBook):

```perl6
use DSL::FiniteStateMachines::AddressBookCaller;

use DSL::Entity::AddressBook;
use DSL::Entity::AddressBook::ResourceAccess;
```
```
# (Any)
```

Here we obtain a resource object to access a (particular) address book:

```perl6
my $resourceObj = DSL::Entity::AddressBook::resource-access-object();
```
```
# DSL::Entity::AddressBook::ResourceAccess.new
```

Here we create the FSM:

```perl6
my DSL::FiniteStateMachines::AddressBookCaller $abcFSM .= new;

$abcFSM.make-machine(($resourceObj,));
```
```
# DSL::FiniteStateMachines::AddressBookCaller.new(dataset => $[{:Company("Caribbean Pirates"), :DiscordHandle("bill.nighy#5415"), :Email("bill.nighy808\@icloud.com"), :Name("Bill Nighy"), :Phone("709-606-7259"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("geoffrey.rush#5746"), :Email("geoffrey.rush1387\@gmail.com"), :Name("Geoffrey Rush"), :Phone("797-199-7144"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("jack.davenport#1324"), :Email("jack.davenport.152\@icloud.net"), :Name("Jack Davenport"), :Phone("627-500-7919"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("johnny.depp#4779"), :Email("johnny.depp1384\@icloud.net"), :Name("Johnny Depp"), :Phone("264-658-5603"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("keira.knightley#4119"), :Email("keira.knightley.1787\@gmail.com"), :Name("Keira Knightley"), :Phone("492-450-8455"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("orlando.bloom#9885"), :Email("orlando.bloom1515\@icloud.com"), :Name("Orlando Bloom"), :Phone("306-504-2824"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("stellan.skarsgård#3933"), :Email("stellan.skarsgård.884\@aol.net"), :Name("Stellan Skarsgård"), :Phone("768-947-8004"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("gore.verbinski#2866"), :Email("gore.verbinski214\@gmail.com"), :Name("Gore Verbinski"), :Phone("261-186-8075"), :Position("director")}, {:Company("Caribbean Pirates"), :DiscordHandle("bruce.hendricks#1695"), :Email("bruce.hendricks.603\@aol.com"), :Name("Bruce Hendricks"), :Phone("193-488-6708"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("chad.oman#7803"), :Email("chad.oman1840\@aol.com"), :Name("Chad Oman"), :Phone("154-609-2847"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("eric.mcleod#7782"), :Email("eric.mcleod214\@icloud.com"), :Name("Eric McLeod"), :Phone("177-425-9150"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("jerry.bruckheimer#7895"), :Email("jerry.bruckheimer.438\@gmail.net"), :Name("Jerry Bruckheimer"), :Phone("794-128-7138"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("mike.stenson#7395"), :Email("mike.stenson1500\@icloud.net"), :Name("Mike Stenson"), :Phone("602-771-9386"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("paul.deason#3944"), :Email("paul.deason925\@icloud.com"), :Name("Paul Deason"), :Phone("626-644-5930"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("andy.serkis#8484"), :Email("andy.serkis.981\@gmail.com"), :Name("Andy Serkis"), :Phone("408-573-4472"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("elijah.wood#7282"), :Email("elijah.wood.53\@aol.com"), :Name("Elijah Wood"), :Phone("321-985-9291"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("ian.mckellen#9077"), :Email("ian.mckellen581\@aol.com"), :Name("Ian McKellen"), :Phone("298-517-5842"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("liv.tyler#8284"), :Email("liv.tyler1177\@gmail.com"), :Name("Liv Tyler"), :Phone("608-925-5727"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("orlando.bloom#6219"), :Email("orlando.bloom.914\@gmail.net"), :Name("Orlando Bloom"), :Phone("570-406-4260"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("sean.astin#1753"), :Email("sean.astin.1852\@gmail.net"), :Name("Sean Astin"), :Phone("365-119-3172"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("viggo.mortensen#7157"), :Email("viggo.mortensen1293\@icloud.com"), :Name("Viggo Mortensen"), :Phone("287-691-8138"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("peter.jackson#7898"), :Email("peter.jackson4\@gmail.com"), :Name("Peter Jackson"), :Phone("484-807-9239"), :Position("director")}, {:Company("LOTR"), :DiscordHandle("barrie.m..osborne#9073"), :Email("barrie.m..osborne.1720\@aol.com"), :Name("Barrie M. Osborne"), :Phone("477-698-8956"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("fran.walsh#8868"), :Email("fran.walsh.1821\@gmail.com"), :Name("Fran Walsh"), :Phone("438-136-7149"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("harvey.weinstein#9310"), :Email("harvey.weinstein.1290\@aol.com"), :Name("Harvey Weinstein"), :Phone("235-361-1101"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("mark.ordesky#3532"), :Email("mark.ordesky1486\@gmail.com"), :Name("Mark Ordesky"), :Phone("282-961-3838"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("michael.lynne#5239"), :Email("michael.lynne714\@gmail.net"), :Name("Michael Lynne"), :Phone("541-362-9877"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("peter.jackson#1255"), :Email("peter.jackson64\@gmail.com"), :Name("Peter Jackson"), :Phone("484-807-9239"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("robert.shaye#6399"), :Email("robert.shaye.768\@gmail.com"), :Name("Robert Shaye"), :Phone("292-252-6866"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("tim.sanders#2122"), :Email("tim.sanders.49\@icloud.com"), :Name("Tim Sanders"), :Phone("791-486-8246"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("anna.paquin#7148"), :Email("anna.paquin.1696\@gmail.net"), :Name("Anna Paquin"), :Phone("832-505-3277"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("famke.janssen#1500"), :Email("famke.janssen477\@icloud.com"), :Name("Famke Janssen"), :Phone("563-508-9902"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("halle.berry#8811"), :Email("halle.berry.297\@aol.net"), :Name("Halle Berry"), :Phone("701-230-8879"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("hugh.jackman#1391"), :Email("hugh.jackman.523\@aol.com"), :Name("Hugh Jackman"), :Phone("940-463-2296"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("ian.mckellen#6302"), :Email("ian.mckellen1398\@aol.net"), :Name("Ian McKellen"), :Phone("900-527-2394"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("james.mcavoy#2046"), :Email("james.mcavoy1626\@aol.net"), :Name("James McAvoy"), :Phone("418-516-9453"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("jennifer.lawrence#9357"), :Email("jennifer.lawrence.1477\@aol.com"), :Name("Jennifer Lawrence"), :Phone("992-883-2904"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("michael.fassbender#7355"), :Email("michael.fassbender.1942\@icloud.net"), :Name("Michael Fassbender"), :Phone("154-359-7691"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("patrick.stewart#6701"), :Email("patrick.stewart.1700\@gmail.com"), :Name("Patrick Stewart"), :Phone("521-101-3722"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("peter.dinklage#3887"), :Email("peter.dinklage.375\@icloud.com"), :Name("Peter Dinklage"), :Phone("441-953-8321"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("brett.ratner#3846"), :Email("brett.ratner1546\@icloud.net"), :Name("Brett Ratner"), :Phone("418-713-2753"), :Position("director")}, {:Company("X-Men"), :DiscordHandle("bryan.singer#1067"), :Email("bryan.singer1916\@icloud.com"), :Name("Bryan Singer"), :Phone("422-832-5218"), :Position("director")}, {:Company("X-Men"), :DiscordHandle("avi.arad#8696"), :Email("avi.arad1747\@aol.com"), :Name("Avi Arad"), :Phone("538-494-2253"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("bryan.singer#5801"), :Email("bryan.singer.22\@gmail.com"), :Name("Bryan Singer"), :Phone("422-832-5218"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("john.palermo#9526"), :Email("john.palermo.1056\@aol.net"), :Name("John Palermo"), :Phone("816-344-9366"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("lauren.shuler.donner#5886"), :Email("lauren.shuler.donner2178\@icloud.com"), :Name("Lauren Shuler Donner"), :Phone("944-706-9217"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("matthew.vaughn#8750"), :Email("matthew.vaughn1182\@gmail.com"), :Name("Matthew Vaughn"), :Phone("875-877-1317"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("ralph.winter#4709"), :Email("ralph.winter1419\@aol.net"), :Name("Ralph Winter"), :Phone("652-415-1269"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("richard.donner#1820"), :Email("richard.donner.182\@aol.net"), :Name("Richard Donner"), :Phone("849-923-9946"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("simon.kinberg#8029"), :Email("simon.kinberg.807\@icloud.net"), :Name("Simon Kinberg"), :Phone("781-187-2762"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("stan.lee#4465"), :Email("stan.lee596\@aol.net"), :Name("Stan Lee"), :Phone("228-156-5037"), :Position("producer")}], datasetColumnNames => Whatever, initDataset => $[{:Company("Caribbean Pirates"), :DiscordHandle("bill.nighy#5415"), :Email("bill.nighy808\@icloud.com"), :Name("Bill Nighy"), :Phone("709-606-7259"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("geoffrey.rush#5746"), :Email("geoffrey.rush1387\@gmail.com"), :Name("Geoffrey Rush"), :Phone("797-199-7144"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("jack.davenport#1324"), :Email("jack.davenport.152\@icloud.net"), :Name("Jack Davenport"), :Phone("627-500-7919"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("johnny.depp#4779"), :Email("johnny.depp1384\@icloud.net"), :Name("Johnny Depp"), :Phone("264-658-5603"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("keira.knightley#4119"), :Email("keira.knightley.1787\@gmail.com"), :Name("Keira Knightley"), :Phone("492-450-8455"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("orlando.bloom#9885"), :Email("orlando.bloom1515\@icloud.com"), :Name("Orlando Bloom"), :Phone("306-504-2824"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("stellan.skarsgård#3933"), :Email("stellan.skarsgård.884\@aol.net"), :Name("Stellan Skarsgård"), :Phone("768-947-8004"), :Position("actor")}, {:Company("Caribbean Pirates"), :DiscordHandle("gore.verbinski#2866"), :Email("gore.verbinski214\@gmail.com"), :Name("Gore Verbinski"), :Phone("261-186-8075"), :Position("director")}, {:Company("Caribbean Pirates"), :DiscordHandle("bruce.hendricks#1695"), :Email("bruce.hendricks.603\@aol.com"), :Name("Bruce Hendricks"), :Phone("193-488-6708"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("chad.oman#7803"), :Email("chad.oman1840\@aol.com"), :Name("Chad Oman"), :Phone("154-609-2847"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("eric.mcleod#7782"), :Email("eric.mcleod214\@icloud.com"), :Name("Eric McLeod"), :Phone("177-425-9150"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("jerry.bruckheimer#7895"), :Email("jerry.bruckheimer.438\@gmail.net"), :Name("Jerry Bruckheimer"), :Phone("794-128-7138"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("mike.stenson#7395"), :Email("mike.stenson1500\@icloud.net"), :Name("Mike Stenson"), :Phone("602-771-9386"), :Position("producer")}, {:Company("Caribbean Pirates"), :DiscordHandle("paul.deason#3944"), :Email("paul.deason925\@icloud.com"), :Name("Paul Deason"), :Phone("626-644-5930"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("andy.serkis#8484"), :Email("andy.serkis.981\@gmail.com"), :Name("Andy Serkis"), :Phone("408-573-4472"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("elijah.wood#7282"), :Email("elijah.wood.53\@aol.com"), :Name("Elijah Wood"), :Phone("321-985-9291"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("ian.mckellen#9077"), :Email("ian.mckellen581\@aol.com"), :Name("Ian McKellen"), :Phone("298-517-5842"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("liv.tyler#8284"), :Email("liv.tyler1177\@gmail.com"), :Name("Liv Tyler"), :Phone("608-925-5727"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("orlando.bloom#6219"), :Email("orlando.bloom.914\@gmail.net"), :Name("Orlando Bloom"), :Phone("570-406-4260"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("sean.astin#1753"), :Email("sean.astin.1852\@gmail.net"), :Name("Sean Astin"), :Phone("365-119-3172"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("viggo.mortensen#7157"), :Email("viggo.mortensen1293\@icloud.com"), :Name("Viggo Mortensen"), :Phone("287-691-8138"), :Position("actor")}, {:Company("LOTR"), :DiscordHandle("peter.jackson#7898"), :Email("peter.jackson4\@gmail.com"), :Name("Peter Jackson"), :Phone("484-807-9239"), :Position("director")}, {:Company("LOTR"), :DiscordHandle("barrie.m..osborne#9073"), :Email("barrie.m..osborne.1720\@aol.com"), :Name("Barrie M. Osborne"), :Phone("477-698-8956"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("fran.walsh#8868"), :Email("fran.walsh.1821\@gmail.com"), :Name("Fran Walsh"), :Phone("438-136-7149"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("harvey.weinstein#9310"), :Email("harvey.weinstein.1290\@aol.com"), :Name("Harvey Weinstein"), :Phone("235-361-1101"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("mark.ordesky#3532"), :Email("mark.ordesky1486\@gmail.com"), :Name("Mark Ordesky"), :Phone("282-961-3838"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("michael.lynne#5239"), :Email("michael.lynne714\@gmail.net"), :Name("Michael Lynne"), :Phone("541-362-9877"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("peter.jackson#1255"), :Email("peter.jackson64\@gmail.com"), :Name("Peter Jackson"), :Phone("484-807-9239"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("robert.shaye#6399"), :Email("robert.shaye.768\@gmail.com"), :Name("Robert Shaye"), :Phone("292-252-6866"), :Position("producer")}, {:Company("LOTR"), :DiscordHandle("tim.sanders#2122"), :Email("tim.sanders.49\@icloud.com"), :Name("Tim Sanders"), :Phone("791-486-8246"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("anna.paquin#7148"), :Email("anna.paquin.1696\@gmail.net"), :Name("Anna Paquin"), :Phone("832-505-3277"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("famke.janssen#1500"), :Email("famke.janssen477\@icloud.com"), :Name("Famke Janssen"), :Phone("563-508-9902"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("halle.berry#8811"), :Email("halle.berry.297\@aol.net"), :Name("Halle Berry"), :Phone("701-230-8879"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("hugh.jackman#1391"), :Email("hugh.jackman.523\@aol.com"), :Name("Hugh Jackman"), :Phone("940-463-2296"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("ian.mckellen#6302"), :Email("ian.mckellen1398\@aol.net"), :Name("Ian McKellen"), :Phone("900-527-2394"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("james.mcavoy#2046"), :Email("james.mcavoy1626\@aol.net"), :Name("James McAvoy"), :Phone("418-516-9453"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("jennifer.lawrence#9357"), :Email("jennifer.lawrence.1477\@aol.com"), :Name("Jennifer Lawrence"), :Phone("992-883-2904"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("michael.fassbender#7355"), :Email("michael.fassbender.1942\@icloud.net"), :Name("Michael Fassbender"), :Phone("154-359-7691"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("patrick.stewart#6701"), :Email("patrick.stewart.1700\@gmail.com"), :Name("Patrick Stewart"), :Phone("521-101-3722"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("peter.dinklage#3887"), :Email("peter.dinklage.375\@icloud.com"), :Name("Peter Dinklage"), :Phone("441-953-8321"), :Position("actor")}, {:Company("X-Men"), :DiscordHandle("brett.ratner#3846"), :Email("brett.ratner1546\@icloud.net"), :Name("Brett Ratner"), :Phone("418-713-2753"), :Position("director")}, {:Company("X-Men"), :DiscordHandle("bryan.singer#1067"), :Email("bryan.singer1916\@icloud.com"), :Name("Bryan Singer"), :Phone("422-832-5218"), :Position("director")}, {:Company("X-Men"), :DiscordHandle("avi.arad#8696"), :Email("avi.arad1747\@aol.com"), :Name("Avi Arad"), :Phone("538-494-2253"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("bryan.singer#5801"), :Email("bryan.singer.22\@gmail.com"), :Name("Bryan Singer"), :Phone("422-832-5218"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("john.palermo#9526"), :Email("john.palermo.1056\@aol.net"), :Name("John Palermo"), :Phone("816-344-9366"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("lauren.shuler.donner#5886"), :Email("lauren.shuler.donner2178\@icloud.com"), :Name("Lauren Shuler Donner"), :Phone("944-706-9217"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("matthew.vaughn#8750"), :Email("matthew.vaughn1182\@gmail.com"), :Name("Matthew Vaughn"), :Phone("875-877-1317"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("ralph.winter#4709"), :Email("ralph.winter1419\@aol.net"), :Name("Ralph Winter"), :Phone("652-415-1269"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("richard.donner#1820"), :Email("richard.donner.182\@aol.net"), :Name("Richard Donner"), :Phone("849-923-9946"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("simon.kinberg#8029"), :Email("simon.kinberg.807\@icloud.net"), :Name("Simon Kinberg"), :Phone("781-187-2762"), :Position("producer")}, {:Company("X-Men"), :DiscordHandle("stan.lee#4465"), :Email("stan.lee596\@aol.net"), :Name("Stan Lee"), :Phone("228-156-5037"), :Position("producer")}], acquiredData => Any, itemSpec => Any, itemSpecCommand => Any, FSMGrammar => DSL::FiniteStateMachines::AddressBookCaller::FSMGlobalCommand, grammar-args => [DSL::Entity::AddressBook::ResourceAccess.new], states => (my DSL::FiniteStateMachines::State % = :AcquireItem(DSL::FiniteStateMachines::State.new(id => "AcquireItem", action => -> $obj { #`(Block|4579045684496) ... }, implicitNext => Str, explicitNext => Array[DSL::FiniteStateMachines::Transition].new(DSL::FiniteStateMachines::Transition.new(id => "acquired", to => "ActOnItem")))), :ActOnItem(DSL::FiniteStateMachines::State.new(id => "ActOnItem", action => -> $obj { #`(Block|4579045684640) ... }, implicitNext => Str, explicitNext => Array[DSL::FiniteStateMachines::Transition].new(DSL::FiniteStateMachines::Transition.new(id => "stay", to => "ActOnItem"), DSL::FiniteStateMachines::Transition.new(id => "quit", to => "Exit")))), :Exit(DSL::FiniteStateMachines::State.new(id => "Exit", action => -> $obj { #`(Block|4579045684712) ... }, implicitNext => Str, explicitNext => Array[DSL::FiniteStateMachines::Transition].new())), :Help(DSL::FiniteStateMachines::State.new(id => "Help", action => -> $obj { #`(Block|4579045684784) ... }, implicitNext => Str, explicitNext => Array[DSL::FiniteStateMachines::Transition].new(DSL::FiniteStateMachines::Transition.new(id => "helpGiven", to => "WaitForCallCommand")))), :ListOfItems(DSL::FiniteStateMachines::State.new(id => "ListOfItems", action => -> $obj { #`(Block|4579045684856) ... }, implicitNext => Str, explicitNext => Array[DSL::FiniteStateMachines::Transition].new(DSL::FiniteStateMachines::Transition.new(id => "manyItems", to => "WaitForCallCommand"), DSL::FiniteStateMachines::Transition.new(id => "noItems", to => "WaitForCallCommand"), DSL::FiniteStateMachines::Transition.new(id => "noChange", to => "WaitForCallCommand"), DSL::FiniteStateMachines::Transition.new(id => "uniqueItemObtained", to => "AcquireItem")))), :PrioritizedList(DSL::FiniteStateMachines::State.new(id => "PrioritizedList", action => -> $obj { #`(Block|4579045684928) ... }, implicitNext => Str, explicitNext => Array[DSL::FiniteStateMachines::Transition].new(DSL::FiniteStateMachines::Transition.new(id => "priorityListGiven", to => "WaitForCallCommand")))), :WaitForCallCommand(DSL::FiniteStateMachines::State.new(id => "WaitForCallCommand", action => -> $obj { #`(Block|4579045685000) ... }, implicitNext => Str, explicitNext => Array[DSL::FiniteStateMachines::Transition].new(DSL::FiniteStateMachines::Transition.new(id => "translated", to => "WaitForRequest"), DSL::FiniteStateMachines::Transition.new(id => "unchanged", to => "WaitForRequest")))), :WaitForRequest(DSL::FiniteStateMachines::State.new(id => "WaitForRequest", action => -> $obj { #`(Block|4579045685072) ... }, implicitNext => Str, explicitNext => Array[DSL::FiniteStateMachines::Transition].new(DSL::FiniteStateMachines::Transition.new(id => "itemSpec", to => "ListOfItems"), DSL::FiniteStateMachines::Transition.new(id => "startOver", to => "WaitForRequest"), DSL::FiniteStateMachines::Transition.new(id => "prioritize", to => "PrioritizedList"), DSL::FiniteStateMachines::Transition.new(id => "help", to => "Help"), DSL::FiniteStateMachines::Transition.new(id => "quit", to => "Exit"))))), currentStateID => Str, choose-transition => Callable, re-say => -> *@args { #`(Block|4579045685792) ... }, re-warn => proto sub warn (|) {*}, ECHOLOGGING => -> *@args { #`(Block|4579045685936) ... })
```

Here is how the dataset of the create FSM looks like:

```perl6
.say for $abcFSM.dataset.pick(3);
```
```
# {Company => LOTR, DiscordHandle => robert.shaye#6399, Email => robert.shaye.768@gmail.com, Name => Robert Shaye, Phone => 292-252-6866, Position => producer}
# {Company => LOTR, DiscordHandle => sean.astin#1753, Email => sean.astin.1852@gmail.net, Name => Sean Astin, Phone => 365-119-3172, Position => actor}
# {Company => LOTR, DiscordHandle => harvey.weinstein#9310, Email => harvey.weinstein.1290@aol.com, Name => Harvey Weinstein, Phone => 235-361-1101, Position => producer}
```

For an *interactive* execution of the FMS we use the command:

```
#$abcFSM.run('WaitForCallCommand');
```

Here we *run* the FSM with a sequence of commands:

```perl6
$abcFSM.run('WaitForCallCommand', ["call an actor from LOTR", "", "take last three", "", "take the second", "", "", "2", "5", "", "quit"]);
```
```
# 🔊 PLEASE enter call request.
# filter by Position is "actor" and Company is "LOTR"
# 🔊 LISTING items.
# ⚙️ListOfItems: Obtained the records:
# ⚙️+--------------+----------------------+-----------------+---------+--------------------------------+----------+
# ⚙️|    Phone     |    DiscordHandle     |       Name      | Company |             Email              | Position |
# ⚙️+--------------+----------------------+-----------------+---------+--------------------------------+----------+
# ⚙️| 408-573-4472 |   andy.serkis#8484   |   Andy Serkis   |   LOTR  |   andy.serkis.981@gmail.com    |  actor   |
# ⚙️| 321-985-9291 |   elijah.wood#7282   |   Elijah Wood   |   LOTR  |     elijah.wood.53@aol.com     |  actor   |
# ⚙️| 298-517-5842 |  ian.mckellen#9077   |   Ian McKellen  |   LOTR  |    ian.mckellen581@aol.com     |  actor   |
# ⚙️| 608-925-5727 |    liv.tyler#8284    |    Liv Tyler    |   LOTR  |    liv.tyler1177@gmail.com     |  actor   |
# ⚙️| 570-406-4260 |  orlando.bloom#6219  |  Orlando Bloom  |   LOTR  |  orlando.bloom.914@gmail.net   |  actor   |
# ⚙️| 365-119-3172 |   sean.astin#1753    |    Sean Astin   |   LOTR  |   sean.astin.1852@gmail.net    |  actor   |
# ⚙️| 287-691-8138 | viggo.mortensen#7157 | Viggo Mortensen |   LOTR  | viggo.mortensen1293@icloud.com |  actor   |
# ⚙️+--------------+----------------------+-----------------+---------+--------------------------------+----------+
# 🔊 PLEASE enter call request.
# 🔊 LISTING items.
# ⚙️ListOfItems: Obtained the records:
# ⚙️+----------+--------------------------------+-----------------+----------------------+---------+--------------+
# ⚙️| Position |             Email              |       Name      |    DiscordHandle     | Company |    Phone     |
# ⚙️+----------+--------------------------------+-----------------+----------------------+---------+--------------+
# ⚙️|  actor   |  orlando.bloom.914@gmail.net   |  Orlando Bloom  |  orlando.bloom#6219  |   LOTR  | 570-406-4260 |
# ⚙️|  actor   |   sean.astin.1852@gmail.net    |    Sean Astin   |   sean.astin#1753    |   LOTR  | 365-119-3172 |
# ⚙️|  actor   | viggo.mortensen1293@icloud.com | Viggo Mortensen | viggo.mortensen#7157 |   LOTR  | 287-691-8138 |
# ⚙️+----------+--------------------------------+-----------------+----------------------+---------+--------------+
# 🔊 PLEASE enter call request.
# 🔊 LISTING items.
# ⚙️ListOfItems: Obtained the records:
# ⚙️+---------------------------+------------+---------+-----------------+--------------+----------+
# ⚙️|           Email           |    Name    | Company |  DiscordHandle  |    Phone     | Position |
# ⚙️+---------------------------+------------+---------+-----------------+--------------+----------+
# ⚙️| sean.astin.1852@gmail.net | Sean Astin |   LOTR  | sean.astin#1753 | 365-119-3172 |  actor   |
# ⚙️+---------------------------+------------+---------+-----------------+--------------+----------+
# 🔊 ACQUIRE item: {Company => LOTR, DiscordHandle => sean.astin#1753, Email => sean.astin.1852@gmail.net, Name => Sean Astin, Phone => 365-119-3172, Position => actor}
# ⚙️Acquiring contact info for : ⚙️Sean Astin
# 🔊 ACT ON item: {Company => LOTR, DiscordHandle => sean.astin#1753, Email => sean.astin.1852@gmail.net, Name => Sean Astin, Phone => 365-119-3172, Position => actor}
# ⚙️[1] email, [2] phone message, [3] phone call, [4] discord message, or [5] nothing
# ⚙️(choose one...)
# ⚙️message by phone 365-119-3172
# 🔊 ACT ON item: {Company => LOTR, DiscordHandle => sean.astin#1753, Email => sean.astin.1852@gmail.net, Name => Sean Astin, Phone => 365-119-3172, Position => actor}
# ⚙️[1] email, [2] phone message, [3] phone call, [4] discord message, or [5] nothing
# ⚙️(choose one...)
# ⚙️do nothing
# 🔊 SHUTTING down...
```

------

## References

### Repositories

[AAr1] Anton Antonov,
[DSL::Shared Raku package](https://github.com/antononcube/Raku-DSL-Shared),
(2020),
[GitHub/antononcube](https://github.com/antononcube).

[AAr2] Anton Antonov,
[DSL::Entity::Metadata Raku package](https://github.com/antononcube/Raku-DSL-Entity-Metadata),
(2021),
[GitHub/antononcube](https://github.com/antononcube).

[AAr3] Anton Antonov,
[DSL::English::DataAcquisitionWorkflows Raku package](https://github.com/antononcube/Raku-DSL-English-DataAcquisitionWorkflows),
(2021),
[GitHub/antononcube](https://github.com/antononcube).

### Videos

[AAv1] Anton Antonov,
["Multi-language Data Wrangling and Acquisition Conversational Agents (in Raku)"](https://www.youtube.com/watch?v=3OUkSa-5vEk),
(2021),
[YouTube.com](https://www.youtube.com/channel/UC5qMPIsJeztfARXWdIw3Xzw).