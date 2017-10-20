//
//  State.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/20/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import Foundation

struct StateVariables {
    let saved: Double
    let displayed: Double?
    var str: String {
        guard let displayed  = displayed, let s = CalcFormatter.string(for: displayed) else { return "Error" }
        return s
    }
}

enum CalcOperator {
    case add
    case subtract
    case multiply
    case divide
}

enum Transformer {
    case percent
    case signChange
}

enum Transition: Hashable {
    var hashValue: Int {
        switch self {
        case .digit(_):
            return 1
        case .calcOperator(_):
            return 2
        case .transformer(_):
            return 3
        case .equal:
            return 4
        case .clear:
            return 5
        case .allClear:
            return 6
        }
    }

    static func ==(lhs: Transition, rhs: Transition) -> Bool {
        switch (lhs, rhs) {
        case (.digit(_), .digit(_)) :
            return true
        case (.calcOperator(_), .calcOperator(_)) :
            return true
        case (.transformer(_), .transformer(_)) :
            return true
        case (.equal, .equal):
            return true
        case (.clear, .clear):
            return true
        case (.allClear, allClear):
            return true
        default:
            return false
        }
    }

    case digit(Double)
    case calcOperator(CalcOperator)
    case transformer(Transformer)
    case equal
    case clear
    case allClear

}

enum State {
    case steady
    case acceptingOperand1
    case primed
    case acceptingOperand2
}

typealias TransitionFunction = (_ m: StateMachine, _ t: Transition)->()

class TransitionDestination {
    let destinationState: State
    let function: TransitionFunction

    init(destinationState: State, function: @escaping TransitionFunction) {
        self.destinationState = destinationState
        self.function = function
    }
}

typealias TransitionMap = [Transition: TransitionDestination]

class StateMachine {
    var saved: Double
    var displayed: Double
    var str: String {
        guard let s = CalcFormatter.string(for: displayed) else { return "Error" }
        return s
    }
    var state: State
    var transitionsByState = [State: TransitionMap]()

    init() {
        saved = 0
        displayed = 0
        state = .steady

        let digitFunction: TransitionFunction = { (machine, transition) in
            if case let Transition.digit(digit) = transition {
                NSLog("Transitioning with \(digit)")
                machine.displayed = machine.displayed * 10 + digit
            }
        }

        add(transition: .digit(1), from: .steady, to: .steady, performing: digitFunction)
        add(transition: .digit(2), from: .steady, to: .steady, performing: digitFunction)
        add(transition: .digit(3), from: .steady, to: .steady, performing: digitFunction)
        add(transition: .digit(4), from: .steady, to: .steady, performing: digitFunction)
        add(transition: .digit(5), from: .steady, to: .steady, performing: digitFunction)
        add(transition: .digit(6), from: .steady, to: .steady, performing: digitFunction)
        add(transition: .digit(7), from: .steady, to: .steady, performing: digitFunction)
        add(transition: .digit(8), from: .steady, to: .steady, performing: digitFunction)
        add(transition: .digit(9), from: .steady, to: .steady, performing: digitFunction)
        add(transition: .digit(0), from: .steady, to: .steady, performing: digitFunction)

    }

    func perform(transition: Transition) {
        if let map = transitionsByState[state],
            let destination = map[transition] {
            destination.function(self, transition)
            state = destination.destinationState
        }
    }

    func add(transition: Transition, from: State, to: State, performing: @escaping TransitionFunction) {
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
