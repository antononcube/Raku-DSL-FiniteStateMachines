role DSL::FiniteStateMachines::FSMReactish {

    #======================================================
    # Initial message run
    #======================================================
    #| Sets initial state that waits for message(s) to react upon.
    method react-ready-with(Str $initID) {

        # Check state
        if self.states{$initID}:!exists {
            self.re-warn.("Unknown initial state ID: ⎡$initID⎦");
            return Nil;
        }

        # Initial states
        self.currentStateID = $initID;
        return True;
    }

    #======================================================
    # Message run
    #======================================================
    #| Flushes the transitions over chains of state connections that
    #| do not requires user input.
    multi method flush-react() {

        # Localize state object
        my Str $stateID = self.currentStateID;
        my $state = self.states{$stateID};

        # State check
        without $state {
            # die "No state for ⎡$stateID⎦" unless $state eq 'None';
            return $stateID;
        }

        if $state.with-input {
            # Just return it
            return $stateID;
        }

        # No input is expected

        # Run the actions
        $stateID = self.choose-transition($stateID, Whatever);
        self.ECHOLOGGING.("\t", "flush reaction new: ", (:$stateID));

        self.currentStateID = $stateID;

        return self.flush-react();
    }

    #| Main reaction function.
    multi method react-to(Str $input) {

        # Check if end-session is reached
        if self.currentStateID eq 'None' {
            note 'FSM run has reached ⎡None⎦.';
            return 'None';
        }

        # Localize state object
        my Str $stateID = self.currentStateID;
        my $state = self.states{$stateID};

        #--------------------------------------------------
        # Run the message
        #--------------------------------------------------

        # State check
        without $state { die "No state for ⎡$stateID⎦" }

        self.ECHOLOGGING.("\t", '$state.id' => $state.id);
        self.ECHOLOGGING.("\t", '$state.Str' => $state.Str);

        # Execute state's action
        # Note that the _real_ state action is programmed with choose-transition(...).
        $state.action.(self);

        # Transition
        if $state.implicitNext {
            # Switch with implicit state

            self.ECHOLOGGING.("\t", '$state.implicitNext => ', $state.implicitNext);
            self.currentStateID = $state.implicitNext;

        } elsif $state.explicitNext && $state.explicitNext.elems > 0 {
            # Switch to explicit state

            self.ECHOLOGGING.("\t", '$state.explicitNext.Str' => $state.explicitNext.raku);
            self.ECHOLOGGING.("\t", '$input.Str' => $input.raku);

            # Run the actions
            $stateID = self.choose-transition($state.id, $input);
            self.ECHOLOGGING.("\t", "new ", (:$stateID));

            self.currentStateID = $stateID;
            $state = self.states{$stateID};

        } else {
            self.ECHOLOGGING.("\t", "no change", '$stateID' => $stateID);
            self.currentStateID = $state.id;
        }

        return self.flush-react();
    }

}