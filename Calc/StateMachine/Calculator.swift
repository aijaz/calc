//
//  Calculator.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/20/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import Foundation

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
        case .point:
            return 7
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
        case (.point, .point):
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
    case point

}

enum State {
    case steady
    case acceptingOperand1
    case primed
    case acceptingOperand2
}




class Calculator {
    var saved: Double
    var displayed: Double
    var pointEntered: Bool
    var numFractionalDigits: Int
    var str: String {
        guard let s = CalcFormatter.string(for: displayed) else { return "Error" }
        if self.pointEntered && self.numFractionalDigits == 0 {
            return "\(s)."
        }
        return s
    }

    let machine = StateMachine<State, Transition>(state: .steady)

    init() {
        saved = 0
        displayed = 0
        pointEntered = false
        numFractionalDigits = 0




        let digitFunction: TransitionFunction<State, Transition> = { (machine, transition) in
            if case let Transition.digit(digit) = transition {
                NSLog("Transitioning with \(digit)")
                if self.pointEntered {
                    self.numFractionalDigits += 1
                    var multiplicant:Double = 1.0
                    for _ in 0 ..< self.numFractionalDigits {
                        multiplicant *= Double(0.1)
                    }
                    self.displayed += (digit * multiplicant)
                }
                else {
                    self.displayed = self.displayed * 10 + digit
                }
            }
        }

        for i in 0 ... 9 {
            NSLog("i is \(i)")
            machine.add(transition: .digit(Double(i)), from: .steady, to: .steady, performing: digitFunction)
        }

        let pointFunction: TransitionFunction<State, Transition> = { (machine, transition) in
            if self.pointEntered { return }
            self.pointEntered = true

        }
        machine.add(transition: .point, from: .steady, to: .steady, performing: pointFunction)


    }

    func keyPressed(_ transition: Transition) {
        machine.perform(transition: transition)
    }
}

