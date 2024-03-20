role DSL::FiniteStateMachines::FSMMessaging {

    #======================================================
    # Initial message run
    #======================================================
    method init-message-run(Str $initID) {

        # Check state
        if self.states{$initID}:!exists {
            self.re-warn.( "Unknown initial state ID: ⎡$initID⎦" );
            return Nil;
        }

        # Initial states
        self.currentStateID = $initID;
        return True;
    }

    #======================================================
    # Message run
    #======================================================
    method message-run(Str $input) {

        # Localize state object
        my Str $stateID = self.currentStateID;
        my $state = self.states{$stateID};

        #--------------------------------------------------
        # Run the message
        #--------------------------------------------------

        if so $state {
            self.ECHOLOGGING.("\t", '$state.id' => $state.id);
            self.ECHOLOGGING.("\t", '$state.Str' => $state.Str);
        } else {
            self.ECHOLOGGING.("\t", '$state => Nil');
        }

        # Execute the action
        $state.action.(self) if so $state;

        without $state { die 'no state' }

        if $state and so $state.implicitNext {
            # Switch with implicit state

            self.ECHOLOGGING.( "\t", '$state.implicitNext => ', $state.implicitNext);
            $stateID = $state.implicitNext;
            $state = self.states{$stateID};

        } elsif $state.explicitNext and $state.explicitNext.elems > 0 {
            # Switch to explicit state

            self.ECHOLOGGING.("\t", '$state.explicitNext.Str' => $state.explicitNext.raku );
            self.ECHOLOGGING.("\t", '$inputs.Str' => $input.raku );

            $stateID = self.choose-transition($state.id, $input);
            self.ECHOLOGGING.("\t" , "new ", '$stateID' => $stateID );

            $state = self.states{$stateID}

        } else {
            self.currentStateID = $state.id;
            return True;
        }

        self.ECHOLOGGING.("\tsingle message processing end : ", '$inputs.Str' => $input );
        if so $state {
            self.ECHOLOGGING.("\tsingle message processing end : ", '$state.Str' => $state.Str);
            self.ECHOLOGGING.("\tsingle message processing end : ", '$state.implicitNext.so' => $state.implicitNext.so);
        } else {
            self.ECHOLOGGING.("\tsingle message processing end : ", '$state => Nil');
        }
        #--------------------------------------------------

        self.currentStateID = $state.id;
        return True;
    }

}