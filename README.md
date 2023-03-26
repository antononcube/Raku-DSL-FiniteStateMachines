# Raku DSL::FiniteStateMachines
    
[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic_2.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)

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

Here we create the FSM and show its states:

```perl6
my DSL::FiniteStateMachines::AddressBookCaller $abcFSM .= new;

$abcFSM.make-machine(($resourceObj,));

.say for $abcFSM.states;
```
```
# PrioritizedList => State object < id => PrioritizedList, action => -> $obj { #`(Block|6268295504336) ... } >
# ListOfItems => State object < id => ListOfItems, action => -> $obj { #`(Block|6268295504408) ... } >
# Exit => State object < id => Exit, action => -> $obj { #`(Block|6268295504480) ... } >
# WaitForRequest => State object < id => WaitForRequest, action => -> $obj { #`(Block|6268295504552) ... } >
# WaitForCallCommand => State object < id => WaitForCallCommand, action => -> $obj { #`(Block|6268295504624) ... } >
# ActOnItem => State object < id => ActOnItem, action => -> $obj { #`(Block|6268295504696) ... } >
# Help => State object < id => Help, action => -> $obj { #`(Block|6268295504768) ... } >
# AcquireItem => State object < id => AcquireItem, action => -> $obj { #`(Block|6268295504840) ... } >
```

(Each pair shows the name of the state object and the object itself.)

Here is the graph of FSM's state transitions:

```perl6, output.prompt=NONE, output-lang=mermaid
$abcFSM.to-mermaid-js
```
```mermaid
graph TD
	PrioritizedList --> |priorityListGiven|WaitForCallCommand
	ListOfItems --> |manyItems|WaitForCallCommand
	ListOfItems --> |noItems|WaitForCallCommand
	ListOfItems --> |noChange|WaitForCallCommand
	ListOfItems --> |uniqueItemObtained|AcquireItem
	
	WaitForRequest --> |itemSpec|ListOfItems
	WaitForRequest --> |startOver|WaitForRequest
	WaitForRequest --> |prioritize|PrioritizedList
	WaitForRequest --> |help|Help
	WaitForRequest --> |quit|Exit
	WaitForCallCommand --> |translated|WaitForRequest
	WaitForCallCommand --> |unchanged|WaitForRequest
	ActOnItem --> |stay|ActOnItem
	ActOnItem --> |quit|Exit
	Help --> |helpGiven|WaitForCallCommand
	AcquireItem --> |acquired|ActOnItem
```

Here is how the dataset of the created FSM looks like:

```perl6
.say for $abcFSM.dataset.pick(3);
```
```
# {Company => LOTR, DiscordHandle => sean.astin#1753, Email => sean.astin.1852@gmail.net, Name => Sean Astin, Phone => 365-119-3172, Position => actor}
# {Company => X-Men, DiscordHandle => richard.donner#1820, Email => richard.donner.182@aol.net, Name => Richard Donner, Phone => 849-923-9946, Position => producer}
# {Company => Caribbean Pirates, DiscordHandle => geoffrey.rush#5746, Email => geoffrey.rush1387@gmail.com, Name => Geoffrey Rush, Phone => 797-199-7144, Position => actor}
```

For an *interactive* execution of the FSM we use the command:

```
#$abcFSM.run('WaitForCallCommand');
```

Here we *run* the FSM with a sequence of commands:

```perl6
$abcFSM.run('WaitForCallCommand', 
        ["call an actor from LOTR", "", 
         "take last three", "", 
         "take the second", "", "", 
         "2", "5", "", 
         "quit"]);
```
```
# 🔊 PLEASE enter call request.
# ⚙️Input: ⚙️"call an actor from LOTR"
# ⚙️Translated input: ⚙️filter by Position is "actor" and Company is "LOTR"
# 🔊 LISTING items.
# ⚙️ListOfItems: Obtained the records:
# ⚙️+----------------------+--------------+----------+--------------------------------+-----------------+---------+
# ⚙️|    DiscordHandle     |    Phone     | Position |             Email              |       Name      | Company |
# ⚙️+----------------------+--------------+----------+--------------------------------+-----------------+---------+
# ⚙️|   andy.serkis#8484   | 408-573-4472 |  actor   |   andy.serkis.981@gmail.com    |   Andy Serkis   |   LOTR  |
# ⚙️|   elijah.wood#7282   | 321-985-9291 |  actor   |     elijah.wood.53@aol.com     |   Elijah Wood   |   LOTR  |
# ⚙️|  ian.mckellen#9077   | 298-517-5842 |  actor   |    ian.mckellen581@aol.com     |   Ian McKellen  |   LOTR  |
# ⚙️|    liv.tyler#8284    | 608-925-5727 |  actor   |    liv.tyler1177@gmail.com     |    Liv Tyler    |   LOTR  |
# ⚙️|  orlando.bloom#6219  | 570-406-4260 |  actor   |  orlando.bloom.914@gmail.net   |  Orlando Bloom  |   LOTR  |
# ⚙️|   sean.astin#1753    | 365-119-3172 |  actor   |   sean.astin.1852@gmail.net    |    Sean Astin   |   LOTR  |
# ⚙️| viggo.mortensen#7157 | 287-691-8138 |  actor   | viggo.mortensen1293@icloud.com | Viggo Mortensen |   LOTR  |
# ⚙️+----------------------+--------------+----------+--------------------------------+-----------------+---------+
# 🔊 PLEASE enter call request.
# ⚙️Input: ⚙️"take last three"
# 🔊 LISTING items.
# ⚙️ListOfItems: Obtained the records:
# ⚙️+--------------------------------+----------+---------+--------------+----------------------+-----------------+
# ⚙️|             Email              | Position | Company |    Phone     |    DiscordHandle     |       Name      |
# ⚙️+--------------------------------+----------+---------+--------------+----------------------+-----------------+
# ⚙️|  orlando.bloom.914@gmail.net   |  actor   |   LOTR  | 570-406-4260 |  orlando.bloom#6219  |  Orlando Bloom  |
# ⚙️|   sean.astin.1852@gmail.net    |  actor   |   LOTR  | 365-119-3172 |   sean.astin#1753    |    Sean Astin   |
# ⚙️| viggo.mortensen1293@icloud.com |  actor   |   LOTR  | 287-691-8138 | viggo.mortensen#7157 | Viggo Mortensen |
# ⚙️+--------------------------------+----------+---------+--------------+----------------------+-----------------+
# 🔊 PLEASE enter call request.
# ⚙️Input: ⚙️"take the second"
# 🔊 LISTING items.
# ⚙️ListOfItems: Obtained the records:
# ⚙️+---------+-----------------+----------+------------+--------------+---------------------------+
# ⚙️| Company |  DiscordHandle  | Position |    Name    |    Phone     |           Email           |
# ⚙️+---------+-----------------+----------+------------+--------------+---------------------------+
# ⚙️|   LOTR  | sean.astin#1753 |  actor   | Sean Astin | 365-119-3172 | sean.astin.1852@gmail.net |
# ⚙️+---------+-----------------+----------+------------+--------------+---------------------------+
# 🔊 ACQUIRE item: {Company => LOTR, DiscordHandle => sean.astin#1753, Email => sean.astin.1852@gmail.net, Name => Sean Astin, Phone => 365-119-3172, Position => actor}
# ⚙️Acquiring contact info for : ⚙️Sean Astin
# 🔊 ACT ON item: {Company => LOTR, DiscordHandle => sean.astin#1753, Email => sean.astin.1852@gmail.net, Name => Sean Astin, Phone => 365-119-3172, Position => actor}
# ⚙️[1] email, [2] phone message, [3] phone call, [4] discord message, or [5] nothing
# ⚙️(choose one...)
# ⚙️Input: ⚙️"2"
# ⚙️message by phone 365-119-3172
# 🔊 ACT ON item: {Company => LOTR, DiscordHandle => sean.astin#1753, Email => sean.astin.1852@gmail.net, Name => Sean Astin, Phone => 365-119-3172, Position => actor}
# ⚙️[1] email, [2] phone message, [3] phone call, [4] discord message, or [5] nothing
# ⚙️(choose one...)
# ⚙️Input: ⚙️"5"
# ⚙️do nothing
# 🔊 SHUTTING down...
```

------

## Object Oriented Design

Here is the Unified Modeling Language (UML) diagram corresponding to the classes in this package:

```mermaid
classDiagram
class DSL_FiniteStateMachines_DataObtainer {
  +$!FSMGrammar
  +$!acquiredData
  +$!currentStateID
  +$!dataset
  +$!datasetColumnNames
  +$!initDataset
  +$!itemSpec
  +$!itemSpecCommand
  +%!states
  +&!ECHOLOGGING
  +&!choose-transition
  +&!re-say
  +&!re-warn
  +@!grammar-args
  +BUILDALL()
  +ECHOLOGGING()
  +FSMGrammar()
  +acquiredData()
  +add-state()
  +add-transition()
  +apply-query-retrieve-act-pattern()
  +choose-transition()
  +currentStateID()
  +dataset()
  +datasetColumnNames()
  +grammar-args()
  +init-dataset()
  +initDataset()
  +is-metadata-dataset()
  +is-metadata-row()
  +itemSpec()
  +itemSpecCommand()
  +make-machine()
  +re-say()
  +re-warn()
  +run()
  +states()
  +to-wl()
  +transition-target()
}
DSL_FiniteStateMachines_DataObtainer --|> DSL_FiniteStateMachines_FSMish
DSL_FiniteStateMachines_DataObtainer --|> DSL_FiniteStateMachines_QueryRetrieveActFSMRole


class DSL_FiniteStateMachines_State {
  +$!id
  +$!implicitNext
  +&!action
  +@!explicitNext
  +BUILDALL()
  +Str()
  +action()
  +explicitNext()
  +gist()
  +id()
  +implicitNext()
  +to-wl()
}

class DSL_FiniteStateMachines_Transition {
  +$!id
  +$!to
  +BUILDALL()
  +Str()
  +gist()
  +id()
  +to()
}

class DSL_FiniteStateMachines_QueryRetrieveActFSMRole {
  <<role>>
  +$!FSMGrammar
  +$!acquiredData
  +$!dataset
  +$!datasetColumnNames
  +$!initDataset
  +$!itemSpec
  +$!itemSpecCommand
  +@!grammar-args
  +apply-query-retrieve-act-pattern()
  +init-dataset()
  +is-metadata-dataset()
  +is-metadata-row()
}
DSL_FiniteStateMachines_QueryRetrieveActFSMRole --|> DSL_FiniteStateMachines_FSMish


class DSL_FiniteStateMachines_AddressBookCaller {
  +$!FSMGrammar
  +$!acquiredData
  +$!currentStateID
  +$!dataset
  +$!datasetColumnNames
  +$!initDataset
  +$!itemSpec
  +$!itemSpecCommand
  +%!states
  +&!ECHOLOGGING
  +&!choose-transition
  +&!re-say
  +&!re-warn
  +@!grammar-args
  +BUILDALL()
  +ECHOLOGGING()
  +FSMGrammar()
  +acquiredData()
  +add-state()
  +add-transition()
  +apply-query-retrieve-act-pattern()
  +choose-transition()
  +currentStateID()
  +dataset()
  +datasetColumnNames()
  +grammar-args()
  +init-dataset()
  +initDataset()
  +is-metadata-dataset()
  +is-metadata-row()
  +itemSpec()
  +itemSpecCommand()
  +make-machine()
  +re-say()
  +re-warn()
  +run()
  +states()
  +to-wl()
  +transition-target()
}
DSL_FiniteStateMachines_AddressBookCaller --|> DSL_FiniteStateMachines_FSMish
DSL_FiniteStateMachines_AddressBookCaller --|> DSL_FiniteStateMachines_QueryRetrieveActFSMRole


class DSL_FiniteStateMachines_FSMish {
  <<role>>
  +$!currentStateID
  +%!states
  +&!ECHOLOGGING
  +&!choose-transition
  +&!re-say
  +&!re-warn
  +add-state()
  +run()
  +to-wl()
}
```

(The [UML spec](./docs/UML-class-diagram.puml) and the Mermaid spec above were automatically generated with ["UML::Translators"](https://raku.land/zef:antononcube/UML::Translators), [AAp5].)

Here is the MermaidJS spec generation shell command:

```
to-uml-spec --format=MermaidJS DSL::FiniteStateMachines 
```

------

## References

### Packages

[AAp1] Anton Antonov,
[DSL::Shared Raku package](https://github.com/antononcube/Raku-DSL-Shared),
(2020),
[GitHub/antononcube](https://github.com/antononcube).

[AAp2] Anton Antonov,
[DSL::Entity::Metadata Raku package](https://github.com/antononcube/Raku-DSL-Entity-Metadata),
(2021),
[GitHub/antononcube](https://github.com/antononcube).

[AAp3] Anton Antonov,
[DSL::English::DataAcquisitionWorkflows Raku package](https://github.com/antononcube/Raku-DSL-English-DataAcquisitionWorkflows),
(2021),
[GitHub/antononcube](https://github.com/antononcube).

[AAp4] Anton Antonov,
[DSL::Entity::AddressBook Raku package](https://github.com/antononcube/Raku-DSL-Entity-AddressBook),
(2023),
[GitHub/antononcube](https://github.com/antononcube).

[AAp5] Anton Antonov,
[UML::Translators Raku package](https://github.com/antononcube/Raku-UML-Translators),
(2021),
[GitHub/antononcube](https://github.com/antononcube).

### Videos

[AAv1] Anton Antonov,
["Multi-language Data Wrangling and Acquisition Conversational Agents (in Raku)"](https://www.youtube.com/watch?v=3OUkSa-5vEk),
(2021),
[YouTube.com](https://www.youtube.com/channel/UC5qMPIsJeztfARXWdIw3Xzw).