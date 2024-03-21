
#===========================================================
# Original version taken from
#   https://rosettacode.org/wiki/Finite_state_machine#Raku
# The original version was programmed in Wolfram Language (WL),
# in order to implement Data Acquisition functionalities.
# See
#   https://github.com/antononcube/ConversationalAgents/blob/master/Packages/WL/OOPFiniteStateMachine.m
#===========================================================

#-----------------------------------------------------------
# Instead of having an &.action callable attribute in DSL::FiniteStateMachines::State
# it is better to have a method. But this brings "deep"
# design implications.

# The core design question is given in two parts:
# - Do the states navigate/traverse the state graph themselves?
#   XOR
# - Does the FSM does "global planning" run?

# The current, implemented design uses the latter:
# 1) The FSM object has the state-transition graph.
# 2) The FSM object knows how to react for given inputs given a state.
# 3) There is multi method chose-transition($stateID, ...) .
#   - The multi-dispatch happens over the first argument ($stateID).
# 4) There is an FSM method run($input, ...) that traverses the FSM graph.

# It seems that $.implicitNext is redundant.

#-----------------------------------------------------------
class DSL::FiniteStateMachines::State {...}
class DSL::FiniteStateMachines::Transition {...}

#-----------------------------------------------------------
class DSL::FiniteStateMachines::State {
    has Str $.id;
    has &.action;
    has Bool $.with-input = False;
    has Str $.implicitNext is rw;
    has DSL::FiniteStateMachines::Transition @.explicitNext;

    method Str {
        return self.gist
    }

    method gist {
        return "State object < id => {$!id}, action => {self.action ?? self.action.raku !! 'None'} >";
    }

    method to-wl() {
        if $.explicitNext {
            my @res = do for @!explicitNext -> $tr {
                "DirectedEdge[\"$!id\",\"{$tr.to}\",\"{$tr.id}\"]";
            }
            @res.join(',')
        } elsif $.implicitNext {
            "DirectedEdge[\"$!id\",\"{$.implicitNext}\"]";
        } else {
            'Nothing'
        }
    }

    method to-mermaid-js(:$arrow is copy = Whatever , :$node-shape is copy = Whatever, Bool :$quoted = False) {

        if $arrow !~~ Str { $arrow = '-->'; }
        if $node-shape !~~ Str { $node-shape = 'rectangle'; }

        my ($lb, $rb);
        given $node-shape {
            when $_.lc ∈ <round round-rectangle> {
                $lb = '(['; $rb = '])';
            }
            when $_.lc ∈ <circle disc ●> {
                $lb = '(('; $rb = '))';
            }
            default {
                $lb = ''; $rb = '';
            }
        }

        if $quoted { $lb = $lb ~ '"'; $rb = '"' ~ $rb; }

        if $.explicitNext {
            my @res = do for @!explicitNext -> $tr {
                "$lb$!id$rb $arrow |{$tr.id}|$lb$($tr.to)$rb";
            }
            @res.join("\n\t")
        } elsif $.implicitNext {
            "$lb$!id$rb $arrow $lb$($.implicitNext)$rb";
        } else {
            ''
        }
    }
}

#-----------------------------------------------------------
class DSL::FiniteStateMachines::Transition {
    has Str $.id;
    has Str $.to;

    method Str {
        return self.gist
    }

    method gist {
        return "Transition object < id => {$!id}, to => {$!to} >"
    }
}

#-----------------------------------------------------------
role DSL::FiniteStateMachines::FSMish {

    has DSL::FiniteStateMachines::State %.states;
    has Str $.currentStateID is rw;
    has &.choose-transition is rw;

    has &.re-say is rw = &say;
    has &.re-warn is rw = &warn;
    has &.ECHOLOGGING is rw = &say;

    #------------------------------------------------------
    multi method add-state(Str $id, &action, Bool $with-input = False) {
        %!states{$id} = DSL::FiniteStateMachines::State.new(:$id, :&action, :$with-input);
    }

    #------------------------------------------------------
    multi method add-state(DSL::FiniteStateMachines::State:D $st) {
        %!states{$st.id} = $st;
    }

    #------------------------------------------------------
    method delete-state(Str $id) {
        %!states{$id}:delete;
        %!states.map({
            $_.value.explicitNext = $_.value.explicitNext.grep({ $_.to ne $id });
            $_.key => $_.value
        });
    }

    #------------------------------------------------------
    multi method add-transition(Str $from, Str $to) {
        %!states{$from}.implicitNext = $to;
    }

    #------------------------------------------------------
    multi method add-transition(Str $from, Str $id, Str $to) {
        %!states{$from}.explicitNext.push: DSL::FiniteStateMachines::Transition.new(:$id, :$to);
    }

    #------------------------------------------------------
    multi method add-transition(Str $from, DSL::FiniteStateMachines::Transition:D $trans) {
        %!states{$from}.explicitNext.push: $trans;
    }

    #------------------------------------------------------
    multi method transition-target(DSL::FiniteStateMachines::Transition @transitions, Str $message) {

        my DSL::FiniteStateMachines::Transition $res = @transitions.first({ $_.id eq $message });

        if not so $res {
            die "Cannot find transitions for the transition id $message";
        }

        return $res.to;
    }

    #------------------------------------------------------
    method run(Str $initID, $inputs is copy = Whatever, UInt $maxLoops = 40) {

        # Verify arguments
        if $inputs.isa(Iterable) { $inputs = $inputs.Array }

        if not ($inputs.isa(Whatever) or $inputs ~~ Array) {
            die "The second argument is expected to be an Array or Whatever.";
        }

        if %!states{$initID}:!exists {
            &!re-warn( "Unknown initial state ID: ⎡$initID⎦" );
            return Nil;
        }

        # Initial states
        my Str $stateID = $initID;
        my $state = %!states{$initID};

        &!ECHOLOGGING("Run: Initial state ID:", (:$initID));

        # Loop to process a sequence of inputs (given or manually entered)
        &!ECHOLOGGING("Run: Main loop...");
        my $k = 0;
        while $k < $maxLoops && ( !$inputs.isa(Array) || $inputs.elems > 0 ) {
            $k++;

            if so $state {
                &!ECHOLOGGING("\t", '$state.id' => $state.id);
                &!ECHOLOGGING("\t", '$state.Str' => $state.Str);
            } else {
                &!ECHOLOGGING("\t", '$state => Nil');
            }

            # Execute the action
            $state.action.(self) if so $state;

            without $state { die 'no state' }

            if $state and so $state.implicitNext {
                # Switch with implicit state

                &!ECHOLOGGING( "\t", '$state.implicitNext => ', $state.implicitNext);
                $stateID = $state.implicitNext;
                $state = %!states{$stateID};

            } elsif $state.explicitNext and $state.explicitNext.elems > 0 {
                # Switch to explicit state

                &!ECHOLOGGING("\t", '$state.explicitNext.Str' => $state.explicitNext.raku );
                &!ECHOLOGGING("\t", '$inputs.Str' => $inputs.raku );

                if $inputs.isa(Array) {
                    # Input sequence is specified
                    # Note that the loop condition checks if $inputs.elems > 0 holds

                    $stateID = self.choose-transition($state.id, $inputs.shift);
                    &!ECHOLOGGING("\t" , "new ", '$stateID' => $stateID );

                } else {
                    # User input is expected

                    $stateID = self.choose-transition( $state.id, Whatever)
                }

                $state = %!states{$stateID}

            } else {
                $!currentStateID = $state.id;
                return True;
            }

            &!ECHOLOGGING("\tloop cycle end : ", '$inputs.Str' => ($inputs.isa(Whatever) ?? 'Whatever' !! $inputs.Str) );
            if so $state {
                &!ECHOLOGGING("\tloop cycle end : ", '$state.Str' => $state.Str);
                &!ECHOLOGGING("\tloop cycle end : ", '$state.implicitNext.so' => $state.implicitNext.so);
            } else {
                &!ECHOLOGGING("\tloop cycle end : ", '$state => Nil');
            }
        }
        &!ECHOLOGGING("Run: ...DONE");

        # If inputs were specified using the last obtained state go through the implicit states
        if $inputs.isa(Array) {
            &!ECHOLOGGING("Run: Post loop implicit states run...");

            $state.action.(self);
            while $state.implicitNext {
                $stateID = $state.implicitNext;
                $state = %!states{$stateID};
                $state.action.(self);

                &!ECHOLOGGING("\t", '$stateID' => $stateID);
            }

            &!ECHOLOGGING("Run: ...DONE")
        }

        $!currentStateID = $state.id;
        return True;
    }

    #------------------------------------------------------
    multi method choose-transition(*@transitions --> Str) {

        &!re-say( "[{.key + 1}] {.value.id}" ) for @transitions.pairs;

        loop {
            my $n = val get;
            return @transitions[$n - 1].to if $n ~~ Int && $n ~~ 1..@transitions;
            say "Invalid input; try again.";
        }
    }

    multi method choose-transition(Str $stateID, $input is copy = Whatever, UInt $maxLoops = 40 --> Str) {

        my $n;
        my @transitions = %!states{$stateID}.explicitNext;

        &!re-say( "[{.key + 1}] {.value.id}" ) for @transitions.pairs;

        my $k = 0;
        while $k < $maxLoops {
            $k++;

            if $input.isa(Whatever) {
                $n = val get;
            } else {
                $n = $input;
            }

            &!re-say("ChooseTransition: Selection ", (:$n));

            if $n ~~ Int && $n ~~ 1..@transitions {
                return @transitions[$n - 1].to;
            } else {
                &!re-say("Invalid input; try again. (One of {(1..^(@transitions.elems+1)).Str}.)");
            }
        }

        &!ECHOLOGGING("ChoseTransition: Reached $maxLoops -- giving up!");
        &!re-warn("ChoseTransition: Reached $maxLoops -- giving up!");

        return @transitions[0].to;
    }

    method to-wl() {
        return 'Graph[#, VertexLabels -> "Name", VertexLabelStyle -> Directive[Bold, Red, Italic, 16], EdgeLabels -> "EdgeTag", EdgeLabelStyle -> Directive[Bold, Blue, Italic, 16], ImageSize -> Large]& @ '
                ~ "List[{%.states.values>>.to-wl.join(',')}]";
    }

    method to-mermaid-js(*%args) {
        return "graph TD\n\t{%.states.values>>.to-mermaid-js(|%args).join("\n\t")}";
    }
}