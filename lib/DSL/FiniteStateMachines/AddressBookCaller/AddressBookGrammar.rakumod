role DSL::FiniteStateMachines::AddressBookCaller::AddressBookGrammar {
  rule call-command($*resourceObj) { <call-contact> | <call-filter> }
  rule call-contact { <.call-preamble> <contact-spec> | [ <.put-verb> | <.get-verb> ] <contact-spec> [<.on-preposition> <.the-determiner> 'phone']? }
  rule call-preamble { <.call-verb> | 'i' 'wanna' 'talk' <.to-preposition> | <.get-verb> }
  #rule contact-spec { [<.the-determiner> | <.a-determiner>]? <contact-occupation>? <call-from-company>? | <contact-name> | <contact-names-list> | [ 'someone' | <.a-determiner>? 'person' ] <call-from-company> }
  rule contact-spec { [<.the-determiner> | <.a-determiner>]? <contact-occupation> <call-from-company>? | <contact-name> | [ 'someone' | <.a-determiner>? 'person' ] <call-from-company> }
  token contact-name { <entity-addressbook-person-name> }
  rule contact-names-list { <contact-name>+ % <.list-separator>}
  rule company-name { <entity-addressbook-company-name> }
  token company-name-part {\S+}
  token contact-occupation {<entity-addressbook-occupation> }
  #rule call-filter {[ <.call-preamble>? [ <call-list-pos-spec> | <call-filter-company> | <call-filter-occupation> [ <call-from-company> ]? | <call-filter-age> | <contact-name> | <contact-names-list> ] ]}
  rule call-filter { <.call-preamble>? [ <call-list-pos-spec> | <call-filter-company> | <call-filter-occupation> [ <call-from-company> ]? | <call-filter-age> | <contact-name> ] }
  rule call-from-company {[ <.from-preposition> | <.of-preposition> ] <.the-determiner>? <.company-noun>? <company-name>}
  rule call-filter-company { [ <.third-person-singular> <.is-verb> ] <call-from-company> | [ <.the-determiner> 'one' ]? <call-from-company> }
  rule call-filter-occupation {[ <.call-preamble>? | [ <.third-person-singular> <.is-verb> ]? [ <.a-determiner> | <.the-determiner> ] ] <contact-occupation>}
  rule call-filter-age { <.the-determiner>? [ 'younger' | 'older' ] 'one'? }
  rule call-list-pos-spec { <.the-determiner>? [ <call-list-num-pos> | 'last' | 'former' | 'latter' ] [ 'one'? | [ 'one'? <.in-preposition> <.the-determiner> <.list-noun> ]? ]}
  rule call-list-num-pos { <position-query-link> } # from DSL::Shared::Roles::English::ListManagementCommand
  rule call-meeting-host { <.call-verb> <.the-determiner> 'host' <.of-preposition> <.the-determiner> 'meeting' <time-spec>}
  rule call-meeting-number { <.call-verb> <call-meeting-number>}
  rule call-meeting-spec { 'my' 'next' 'meeting' | <.the-determiner> 'meeting' [ 'i' 'have' 'now' ]? }
  token call-verb { 'call' | 'dial' }
  token third-person-singular { 'he' | 'she' }
  token company-noun { 'company' }
  token put-verb { 'put' }
}