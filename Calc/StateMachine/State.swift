//
//  State.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/20/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

/// This is the generic state machine that's used by this app.
/// Since it's a swift generic, it can be used with any kind of state and transition classes.
/// The only requirement is that both the type that's used for the state
/// and the type that's used for the transitions conform to the Hashable protocol.

import Foundation


typealias TransitionFunction<StateType:Hashable, TransitionType:Hashable> = (_ m: StateMachine<StateType, TransitionType>, _ t: TransitionType)->()


/// A transition destination is a tuple of a destination state and function to be invoked when transitioning to that destination
class TransitionDestination<StateType:Hashable, TransitionType:Hashable> {
    let destinationState: StateType
    let function: TransitionFunction<StateType, TransitionType>

    init(destinationState: StateType, function: @escaping TransitionFunction<StateType, TransitionType>) {
        self.destinationState = destinationState
        self.function = function
    }
}

/// The generic state machine
class StateMachine<StateType:Hashable, TransitionType:Hashable> {

    /// Maps a transition type to it's destination
    /// A map is used for easy lookup.
    typealias TransitionMap = [TransitionType: TransitionDestination<StateType, TransitionType> ]


    /// the current state
    var state: StateType

    /// a hash of all transitionMaps by state
    var transitionsByState = [StateType: TransitionMap]()

    init(state: StateType) {
        self.state = state
    }

    /// Given a transition, perform it if possible.
    /// It may be that there is no transition of this type from the current state.
    /// In that case, nothing is done.
    /// - parameter transition: the transition to be fired
    func perform(transition: TransitionType) {
        if let map = transitionsByState[state],
            let destination = map[transition] {
            destination.function(self, transition)
            state = destination.destinationState
        }
    }

    /// Add the given transition from a source state to a destination state, executing the given function when transition is fired.
    /// - parameter transition: The transition to be added
    /// - parameter from: The source state
    /// - parameter to: The destination state
    /// - parameter performing: The function to be executed when the transition is fired
    func add(transition: TransitionType, from: StateType, to: StateType, performing: @escaping TransitionFunction<StateType, TransitionType>) {
        let destination = TransitionDestination(destinationState: to, function: performing)
        if let _ = transitionsByState[from] {
            transitionsByState[from]![transition] = destination
        }
        else {
            transitionsByState[from] = TransitionMap()
            transitionsByState[from]![transition] = destination
        }
    }

}
