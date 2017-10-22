//
//  Calculator.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/20/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import Foundation

enum CalcOperator: Int {
    case add
    case subtract
    case multiply
    case divide
}

enum Transformer: Int {
    case percent
    case signChange
}

enum Transition: Hashable {
    var hashValue: Int {
        switch self {
        case .digit(let digit):
            return Int(digit)
        case .calcOperator(let op):
            return 10 + op.rawValue
        case .transformer(let transformer):
            return 20 + transformer.rawValue
        case .equal:
            return 30
        case .clear:
            return 40
        case .allClear:
            return 50
        case .point:
            return 60
        }
    }

    static func ==(lhs: Transition, rhs: Transition) -> Bool {
        switch (lhs, rhs) {
        case (.digit(let d1), .digit(let d2)) :
            return d1 == d2
        case (.calcOperator(let o1), .calcOperator(let o2)) :
            return o1 == o2
        case (.transformer(let t1), .transformer(let t2)) :
            return t1 == t2
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
    case nothingEntered
    case nothingEnteredNegative
    case enteringBeforePoint
    case enteringAfterPoint
    case doneEntering
    case acceptedOperand1
    case nothingEntered2
    case nothingEntered2Negative
    case entering2BeforePoint
    case entering2AfterPoint
    case doneEntering2
    case primed
    case acceptedOperand1Cleared
}




class Calculator {
    var implicit: Double
    var lastOperand: Double?
    var pointEntered: Bool
    var numFractionalDigits: Int
    var str: String
    var plainStr: String
    var displayed: Double
    var entered: Double {
        return Double(str)!
    }
    var lastOperator: CalcOperator?

    let machine = StateMachine<State, Transition>(state: .nothingEntered)


    init() {
        implicit = 0
        displayed = 0
        pointEntered = false
        numFractionalDigits = 0
        str = "0"
        plainStr = "0"

        let addFirstDigit: TransitionFunction<State, Transition> = { (machine, transition) in
            if case let .digit(digit) = transition {
                self.str = "\(Int(digit))"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
        }

        let addDigitToOperand: TransitionFunction<State, Transition> = { (machine, transition) in
            if case let .digit(digit) = transition {
                let tempStr = "\(self.plainStr)\(Int(digit))"
                if tempStr.numDigits <= 9 {
                    self.plainStr = tempStr
                    self.str = CalcFormatter.string(for: Double(self.plainStr)!)!
                    self.displayed = Double(self.plainStr)!
                }
            }
        }

        let addDigitToOperandAfterPoint: TransitionFunction<State, Transition> = { (machine, transition) in
            if case let .digit(digit) = transition {
                let tempStr = "\(self.plainStr)\(Int(digit))"
                if tempStr.numDigits <= 9 {
                    self.plainStr = tempStr
                    self.str = "\(self.str)\(Int(digit))"
                    self.displayed = Double(self.plainStr)!
                }
            }
        }

        let toggleSignOfDisplayed: TransitionFunction<State, Transition> = { (machine, transition) in
            self.displayed *= -1
            self.plainStr = "\(self.displayed)"
            self.str = CalcFormatter.string(for: self.displayed)!
        }

        let reset: TransitionFunction<State, Transition> = { (machine, transition) in
            self.str = "0"
            self.plainStr = "0"
            self.displayed = 0
        }

        let clearSecondOperand: TransitionFunction<State, Transition> = { (machine, transition) in
            self.str = "0"
            self.plainStr = "0"
            self.displayed = 0
        }




        machine.add(transition: .transformer(.signChange), from: .nothingEntered, to: .nothingEnteredNegative) { (machine, transition) in
            self.str = "-0"
        }
        machine.add(transition: .transformer(.signChange), from: .nothingEnteredNegative, to: .nothingEntered) { (machine, transition) in
            self.str = "0"
        }

        for i in 1 ... 9 {
            machine.add(transition: .digit(Double(i)), from: .nothingEntered, to: .enteringBeforePoint, performing: addFirstDigit)

            machine.add(transition: .digit(Double(i)), from: .nothingEnteredNegative, to: .enteringBeforePoint) { (machine, transition) in
                self.str = "-\(i)"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
        }
        machine.add(transition: .point, from: .nothingEntered, to: .enteringAfterPoint) { (machine, transition) in
            self.plainStr = "0."
            self.str = "0."
            self.displayed = Double(self.plainStr)!
        }
        machine.add(transition: .point, from: .nothingEnteredNegative, to: .enteringAfterPoint) { (machine, transition) in
            self.plainStr = "-0."
            self.str = "-0."
            self.displayed = Double(self.plainStr)!
        }

        for i in 0 ... 9 {
            machine.add(transition: .digit(Double(i)), from: .enteringBeforePoint, to: .enteringBeforePoint, performing: addDigitToOperand)
            machine.add(transition: .transformer(.signChange), from: .enteringBeforePoint, to: .enteringBeforePoint, performing: toggleSignOfDisplayed)

        }
        machine.add(transition: .point, from: .enteringBeforePoint, to: .enteringAfterPoint) { (machine, transition) in
            self.plainStr = "\(self.plainStr)."
            self.str = "\(self.str)."
            self.displayed = Double(self.plainStr)!
        }
        for i in 0 ... 9 {
            machine.add(transition: .digit(Double(i)), from: .enteringAfterPoint, to: .enteringAfterPoint, performing: addDigitToOperandAfterPoint)
            machine.add(transition: .transformer(.signChange), from: .enteringAfterPoint, to: .enteringAfterPoint, performing: toggleSignOfDisplayed)
        }

        let ops: [CalcOperator] = [.add, .subtract, .multiply, .divide]
        for oper in ops {
            machine.add(transition: .calcOperator(oper), from: .enteringBeforePoint, to: .acceptedOperand1) { (machine, transition) in
                self.lastOperator = oper
                self.implicit = self.displayed
                self.lastOperand = nil
            }
            machine.add(transition: .calcOperator(oper), from: .enteringAfterPoint, to: .acceptedOperand1) { (machine, transition) in
                self.lastOperator = oper
                self.implicit = self.displayed
                self.lastOperand = nil
            }
            machine.add(transition: .calcOperator(oper), from: .acceptedOperand1, to: .acceptedOperand1) { (machine, transition) in
                self.lastOperator = oper
                self.implicit = self.displayed
                self.lastOperand = nil
            }
            machine.add(transition: .calcOperator(oper), from: .acceptedOperand1Cleared, to: .acceptedOperand1) { (machine, transition) in
                self.lastOperator = oper
                self.implicit = self.displayed
                self.lastOperand = nil
            }
        }


        machine.add(transition: .digit(0), from: .acceptedOperand1, to: .nothingEntered2) { (machine, transition) in
            self.str = "0"
            self.plainStr = self.str
            self.displayed = 0
        }
        machine.add(transition: .digit(0), from: .acceptedOperand1Cleared, to: .nothingEntered2) { (machine, transition) in
            self.str = "0"
            self.plainStr = self.str
            self.displayed = 0
        }
        machine.add(transition: .transformer(.signChange), from: .acceptedOperand1, to: .nothingEntered2Negative) { (machine, transition) in
            self.str = "-0"
            self.plainStr = self.str
            self.displayed = 0
        }
        machine.add(transition: .transformer(.signChange), from: .acceptedOperand1Cleared, to: .nothingEntered2Negative) { (machine, transition) in
            self.str = "-0"
            self.plainStr = self.str
            self.displayed = 0
        }
        machine.add(transition: .transformer(.signChange), from: .nothingEntered2, to: .nothingEntered2Negative) { (machine, transition) in
            self.str = "-0"
            self.plainStr = self.str
            self.displayed = 0
        }
        machine.add(transition: .transformer(.signChange), from: .nothingEntered2Negative, to: .nothingEntered2) { (machine, transition) in
            self.str = "0"
            self.plainStr = self.str
            self.displayed = 0
        }
        for i in 1 ... 9 {
            machine.add(transition: .digit(Double(i)), from: .acceptedOperand1, to: .entering2BeforePoint) { (machine, transition) in
                self.str = "\(i)"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
            machine.add(transition: .digit(Double(i)), from: .acceptedOperand1Cleared, to: .entering2BeforePoint) { (machine, transition) in
                self.str = "\(i)"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
            machine.add(transition: .digit(Double(i)), from: .nothingEntered2, to: .entering2BeforePoint) { (machine, transition) in
                self.str = "\(i)"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
            machine.add(transition: .digit(Double(i)), from: .nothingEntered2Negative, to: .entering2BeforePoint) { (machine, transition) in
                self.str = "-\(i)"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
        }
        machine.add(transition: .point, from: .acceptedOperand1, to: .entering2AfterPoint) { (machine, transition) in
            self.plainStr = "0."
            self.str = "0."
            self.displayed = Double(self.plainStr)!
        }
        machine.add(transition: .point, from: .acceptedOperand1Cleared, to: .entering2AfterPoint) { (machine, transition) in
            self.plainStr = "0."
            self.str = "0."
            self.displayed = Double(self.plainStr)!
        }
        machine.add(transition: .point, from: .nothingEntered2, to: .entering2AfterPoint) { (machine, transition) in
            self.plainStr = "0."
            self.str = "0."
            self.displayed = 0
        }
        machine.add(transition: .point, from: .nothingEntered2Negative, to: .entering2AfterPoint) { (machine, transition) in
            self.plainStr = "-0."
            self.str = "-0."
            self.displayed = 0
        }

        for i in 0 ... 9 {
            machine.add(transition: .digit(Double(i)), from: .entering2BeforePoint, to: .entering2BeforePoint, performing: addDigitToOperand)
            machine.add(transition: .transformer(.signChange), from: .entering2BeforePoint, to: .entering2BeforePoint, performing: toggleSignOfDisplayed)
            machine.add(transition: .digit(Double(i)), from: .entering2AfterPoint, to: .entering2AfterPoint, performing: addDigitToOperandAfterPoint)
            machine.add(transition: .transformer(.signChange), from: .entering2AfterPoint, to: .entering2AfterPoint, performing: toggleSignOfDisplayed)
        }
        machine.add(transition: .point, from: .entering2BeforePoint, to: .entering2AfterPoint) { (machine, transition) in
            self.plainStr = "\(self.plainStr)."
            self.str = "\(self.str)."
            self.displayed = Double(self.plainStr)!
        }



        // =
        let equalHelper = { () in
            var answer: Double = 0
            if let lastOp = self.lastOperator {
                switch lastOp {
                case .add:
                    answer = self.implicit + self.displayed
                case .subtract:
                    answer = self.implicit - self.displayed
                case .multiply:
                    answer = self.implicit * self.displayed
                case .divide:
                    answer = self.implicit / self.displayed
                }
            }
            self.displayAnswer(answer)
        }

        let repeatedEqual: TransitionFunction<State, Transition> = { (machine, transition) in
            if self.lastOperand == nil {
                self.lastOperand = self.implicit
                equalHelper()
                return
            }
            var answer: Double = 0
            if let lastOp = self.lastOperator, let lastOperand = self.lastOperand {
                switch lastOp {
                case .add:
                    answer = self.displayed + lastOperand
                case .subtract:
                    answer = self.displayed - lastOperand
                case .multiply:
                    answer = self.displayed * lastOperand
                case .divide:
                    answer = self.displayed / lastOperand
                }
            }
            self.displayAnswer(answer)
        }

        let equalFunctionChangingLastOperand: TransitionFunction<State, Transition> = { (machine, transition) in
            if self.lastOperand == nil {
                self.lastOperand = self.displayed
            }
            equalHelper()
            self.implicit = self.lastOperand!
        }

        machine.add(transition: .equal, from: .entering2BeforePoint, to: .acceptedOperand1, performing: equalFunctionChangingLastOperand )
        machine.add(transition: .equal, from: .entering2AfterPoint, to: .acceptedOperand1, performing: equalFunctionChangingLastOperand )
        machine.add(transition: .equal, from: .acceptedOperand1, to: .acceptedOperand1, performing: repeatedEqual )
        machine.add(transition: .equal, from: .acceptedOperand1Cleared, to: .acceptedOperand1, performing: repeatedEqual )


        // Transitions for Percentage
        machine.add(transition: .transformer(.percent), from: .nothingEnteredNegative, to: .nothingEntered) { (_, _) in
            self.displayed = 0
            self.str = "0"
            self.plainStr = "0"
        }

        machine.add(transition: .transformer(.percent), from: .enteringBeforePoint, to: .doneEntering) { (_, _) in
            self.displayed /= 100.0
            self.str = CalcFormatter.string(for: self.displayed)!
            self.plainStr = "\(self.displayed)"
        }
        machine.add(transition: .transformer(.percent), from: .enteringAfterPoint, to: .doneEntering) { (_, _) in
            self.displayed /= 100.0
            self.str = CalcFormatter.string(for: self.displayed)!
            self.plainStr = "\(self.displayed)"
        }
        for oper in ops {
            machine.add(transition: .calcOperator(oper), from: .doneEntering, to: .acceptedOperand1) { (machine, transition) in
                self.lastOperator = oper
                self.implicit = self.displayed
                self.lastOperand = nil
            }
        }
        machine.add(transition: .transformer(.percent), from: .entering2BeforePoint, to: .doneEntering2) { (_, _) in
            self.displayed = self.implicit * self.displayed / 100.0
            self.str = CalcFormatter.string(for: self.displayed)!
            self.plainStr = "\(self.displayed)"
        }
        machine.add(transition: .transformer(.percent), from: .entering2AfterPoint, to: .doneEntering2) { (_, _) in
            self.displayed = self.implicit * self.displayed / 100.0
            self.str = CalcFormatter.string(for: self.displayed)!
            self.plainStr = "\(self.displayed)"
        }
        machine.add(transition: .equal, from: .doneEntering2, to: .acceptedOperand1, performing: equalFunctionChangingLastOperand )


        // clear/all clear transitions
        machine.add(transition: .clear, from: .enteringBeforePoint, to: .nothingEntered, performing: reset)
        machine.add(transition: .clear, from: .enteringAfterPoint, to: .nothingEntered, performing: reset)
        machine.add(transition: .clear, from: .acceptedOperand1, to: .acceptedOperand1Cleared, performing: clearSecondOperand)
        machine.add(transition: .clear, from: .nothingEntered2, to: .acceptedOperand1Cleared, performing: clearSecondOperand)
        machine.add(transition: .clear, from: .nothingEntered2Negative, to: .acceptedOperand1Cleared, performing: clearSecondOperand)
        machine.add(transition: .clear, from: .entering2BeforePoint, to: .acceptedOperand1Cleared, performing: clearSecondOperand)
        machine.add(transition: .clear, from: .entering2AfterPoint, to: .acceptedOperand1Cleared, performing: clearSecondOperand)

        machine.add(transition: .allClear, from: .acceptedOperand1Cleared, to: .nothingEntered, performing: reset)
        // copy everything from .acceptedOperand1 to .acceptedOperand1Cleard with the exception of .clear




    }

    fileprivate func displayAnswer(_ answer: Double) {
        if let str = CalcFormatter.string(for: answer) {
            self.plainStr = "\(answer)"
            self.displayed = answer
            self.str = str
        }
        else {
            self.str = "Error"
            self.plainStr = "Error"
            self.displayed = 0
        }
    }


    func keyPressed(_ transition: Transition) {
        machine.perform(transition: transition)
    }
}

