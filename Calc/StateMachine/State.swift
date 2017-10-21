//
//  State.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/20/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import Foundation

//struct StateVariables {
//    let saved: Double
//    let displayed: Double?
//    var str: String {
//        guard let displayed  = displayed, let s = CalcFormatter.string(for: displayed) else { return "Error" }
//        return s
//    }
//}



typealias TransitionFunction<StateType:Hashable, TransitionType:Hashable> = (_ m: StateMachine<StateType, TransitionType>, _ t: TransitionType)->()


class TransitionDestination<StateType:Hashable, TransitionType:Hashable> {
    let destinationState: StateType
    let function: TransitionFunction<StateType, TransitionType>

    init(destinationState: StateType, function: @escaping TransitionFunction<StateType, TransitionType>) {
        self.destinationState = destinationState
        self.function = function
    }
}


class StateMachine<StateType:Hashable, TransitionType:Hashable> {

    typealias TransitionMap = [TransitionType: TransitionDestination<StateType, TransitionType> ]


    var state: StateType
    var transitionsByState = [StateType: TransitionMap]()

    init(state: StateType) {
        self.state = state
    }

    func perform(transition: TransitionType) {
        if let map = transitionsByState[state],
            let destination = map[transition] {
            destination.function(self, transition)
            state = destination.destinationState
        }
    }

    func add(transition: TransitionType, from: StateType, to: StateType, performing: @escaping TransitionFunction<StateType, TransitionType>) {
        let destination = TransitionDestination(destinationState: to, function: performing)
        if var map = transitionsByState[from] {
            map[transition] = destination
        }
        else {
            transitionsByState[from] = TransitionMap()
            transitionsByState[from]![transition] = destination
        }
    }

}
