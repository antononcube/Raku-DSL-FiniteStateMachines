use v6.d;

use DSL::Entity::AddressBook::ResourceAccess;

class DSL::FiniteStateMachines::AddressBookCaller::AddressBookActions {

    ##=====================================================
    ## General
    ##=====================================================
    has Str $.userID is rw;

    has DSL::Entity::AddressBook::ResourceAccess $.resources;

    ##=====================================================
    ## TOP
    ##=====================================================
    method TOP($/) { make $/.values[0].made; }

    ##=====================================================
    ## The rest
    ##=====================================================

    method call-command($/) { make $/.values[0].made; }
    method call-contact($/) { make $/.values[0].made; }
    method call-spec($/) { make $/.values[0].made; }
    method call-filter($/) { make $/.values[0].made; }
    method contact-spec($/) {
        if $<contact-occupation> && $<call-from-company> {
            make 'filter by Position is "' ~ $<contact-occupation>.made ~ '" and Company is "' ~  $<call-from-company>.made ~ '"';
        } elsif $<contact-name> {
            make 'filter by Name is "' ~ $<contact-name>.made ~ '"';
        } elsif $<call-from-company> {
            make 'filter by Company is "' ~  $<call-from-company>.made ~ '"';
        } else {
            make 'filter by Position is "' ~ $<contact-occupation>.made ~ '"';
        }
    }
    method call-from-company($/) { make $/.values[0].made }
    method contact-name($/) { make $/.Str }
    method contact-names-list($/) { make $/.values>>.Str.join(' ') }
    method contact-occupation($/) { make $/.Str }
    method company-name($/) { make $/.values>>.Str.join(' ') }
    method company-name-part($/) { make $/.Str }
}