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
    case acceptedOperand1Cleared
    case operationCompleted
    case nothingEntered3
    case nothingEntered3Negative
    case entering3BeforePoint
    case entering3AfterPoint
    case doneEntering3
}

typealias CalcTransitionFunction = TransitionFunction<State, Transition>


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

        let addFirstDigit: CalcTransitionFunction = { (_, transition) in
            if case let .digit(digit) = transition {
                self.str = "\(Int(digit))"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
        }

        let addDigitToOperand: CalcTransitionFunction = { (_, transition) in
            if case let .digit(digit) = transition {
                let tempStr = "\(self.plainStr)\(Int(digit))"
                if tempStr.numDigits <= 9 {
                    self.plainStr = tempStr
                    self.str = CalcFormatter.string(for: Double(self.plainStr)!)!
                    self.displayed = Double(self.plainStr)!
                }
            }
        }

        let addDigitToOperandAfterPoint: CalcTransitionFunction = { (_, transition) in
            if case let .digit(digit) = transition {
                let tempStr = "\(self.plainStr)\(Int(digit))"
                if tempStr.numDigits <= 9 {
                    self.plainStr = tempStr
                    self.str = "\(self.str)\(Int(digit))"
                    self.displayed = Double(self.plainStr)!
                }
            }
        }

        let toggleSignOfDisplayed: CalcTransitionFunction = { (_, _) in
            self.displayed *= -1
            self.plainStr = "\(self.displayed)"
            self.str = CalcFormatter.string(for: self.displayed)!
        }

        let reset: CalcTransitionFunction = { (_, _) in
            self.str = "0"
            self.plainStr = "0"
            self.displayed = 0
        }

        let clearSecondOperand: CalcTransitionFunction = { (_, _) in
            self.str = "0"
            self.plainStr = "0"
            self.displayed = 0
        }

        let neToNeNeg: CalcTransitionFunction = { (_, _) in
            self.str = "-0"
            self.plainStr = "-0"
            self.displayed = 0
        }

        let neNegToNe: CalcTransitionFunction = { (_, _) in
            self.str = "0"
            self.plainStr = "0"
            self.displayed = 0
        }

        let neNegToEnteringBeforePoint: CalcTransitionFunction = { (_, transition) in
            if case let .digit(digit) = transition {
                self.str = "-\(digit)"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
        }

        let neToEAP: CalcTransitionFunction = { (_, _) in
            self.plainStr = "0."
            self.str = "0."
            self.displayed = Double(self.plainStr)!
        }
        let neNegToEAP: CalcTransitionFunction = { (_, _) in
            self.plainStr = "-0."
            self.str = "-0."
            self.displayed = Double(self.plainStr)!
        }

        let ebpToEap: CalcTransitionFunction = { (_, _) in
            self.plainStr = "\(self.plainStr)."
            self.str = "\(self.str)."
            self.displayed = Double(self.plainStr)!

        }

        let firstOperandPctFunction: CalcTransitionFunction = { (_,_) in
            self.displayed /= 100.0
            self.str = CalcFormatter.string(for: self.displayed)!
            self.plainStr = "\(self.displayed)"
        }

        let acceptFirstOperand: CalcTransitionFunction = { (_,transition) in
            if case let .calcOperator(oper) = transition {
                self.lastOperator = oper
                self.implicit = self.displayed
                self.lastOperand = nil
            }
        }

        func createNumberGatherer(ne: State, neNeg: State, ebp: State, eap: State, done: State, doneFunction: @escaping CalcTransitionFunction) {
            machine.add(transition: .transformer(.signChange), from: ne, to: neNeg, performing: neToNeNeg)
            machine.add(transition: .transformer(.signChange), from: neNeg, to: ne, performing: neNegToNe)
            machine.add(transition: .transformer(.percent), from: neNeg, to: ne, performing: neNegToNe)
            machine.add(transition: .point, from: neNeg, to: eap, performing: neNegToEAP)
            machine.add(transition: .point, from: ne, to: eap, performing: neToEAP)
            machine.add(transition: .point, from: ebp, to: eap, performing: ebpToEap)
            machine.add(transition: .clear, from: ebp, to: ne, performing: reset)
            machine.add(transition: .clear, from: ebp, to: neNeg, performing: reset)


            for i in 1 ... 9 {
                machine.add(transition: .digit(Double(i)), from: ne, to: ebp, performing: addFirstDigit)
                machine.add(transition: .digit(Double(i)), from: neNeg, to: ebp, performing: neNegToEnteringBeforePoint)
            }

            for i in 0 ... 9 {
                machine.add(transition: .digit(Double(i)), from: ebp, to: ebp, performing: addDigitToOperand)
                machine.add(transition: .transformer(.signChange), from: ebp, to: ebp, performing: toggleSignOfDisplayed)
                machine.add(transition: .digit(Double(i)), from: eap, to: eap, performing: addDigitToOperandAfterPoint)
                machine.add(transition: .transformer(.signChange), from: eap, to: eap, performing: toggleSignOfDisplayed)
            }

            machine.add(transition: .transformer(.percent), from: ebp, to: done, performing: doneFunction)
            machine.add(transition: .transformer(.percent), from: eap, to: done, performing: doneFunction)
        }



        createNumberGatherer(ne: .nothingEntered, neNeg: .nothingEnteredNegative, ebp: .enteringBeforePoint, eap: .enteringAfterPoint, done: .doneEntering, doneFunction: firstOperandPctFunction)


        // first operand
        let ops: [CalcOperator] = [.add, .subtract, .multiply, .divide]
        for oper in ops {
            machine.add(transition: .calcOperator(oper), from: .enteringBeforePoint, to: .acceptedOperand1, performing: acceptFirstOperand)
            machine.add(transition: .calcOperator(oper), from: .enteringAfterPoint, to: .acceptedOperand1, performing: acceptFirstOperand)
            machine.add(transition: .calcOperator(oper), from: .doneEntering, to: .acceptedOperand1, performing: acceptFirstOperand )
        }



        machine.add(transition: .digit(0), from: .acceptedOperand1, to: .nothingEntered2, performing: reset)
        machine.add(transition: .digit(0), from: .acceptedOperand1Cleared, to: .nothingEntered2, performing: reset)

        machine.add(transition: .transformer(.signChange), from: .acceptedOperand1, to: .nothingEntered2Negative, performing: neToNeNeg)
        machine.add(transition: .transformer(.signChange), from: .acceptedOperand1Cleared, to: .nothingEntered2Negative, performing: neToNeNeg)

        for i in 1 ... 9 {
            machine.add(transition: .digit(Double(i)), from: .acceptedOperand1, to: .entering2BeforePoint, performing: addFirstDigit)
            machine.add(transition: .digit(Double(i)), from: .acceptedOperand1Cleared, to: .entering2BeforePoint, performing: addFirstDigit)
        }
        machine.add(transition: .point, from: .acceptedOperand1, to: .entering2AfterPoint, performing: neToEAP)
        machine.add(transition: .point, from: .acceptedOperand1Cleared, to: .entering2AfterPoint, performing: neToEAP)

        machine.add(transition: .allClear, from: .acceptedOperand1Cleared, to: .nothingEntered, performing: reset)

        let secondOperandDone: CalcTransitionFunction = { (_,_) in
            self.displayed = self.implicit * self.displayed / 100.0
            self.str = CalcFormatter.string(for: self.displayed)!
            self.plainStr = "\(self.displayed)"
        }

        createNumberGatherer(ne: .nothingEntered2, neNeg: .nothingEntered2Negative, ebp: .entering2BeforePoint, eap: .entering2AfterPoint, done: .doneEntering2, doneFunction: secondOperandDone)

        let equalFunctionTwoOperands: CalcTransitionFunction = { (_,_) in
            self.lastOperand = self.displayed
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
            self.implicit = self.lastOperand!
        }

        let equalMissingSecondOperand: CalcTransitionFunction = { (_,_) in
            self.lastOperand = self.implicit
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

        machine.add(transition: .equal, from: .entering2BeforePoint, to: .operationCompleted, performing: equalFunctionTwoOperands )
        machine.add(transition: .equal, from: .entering2AfterPoint, to: .operationCompleted, performing: equalFunctionTwoOperands )
        machine.add(transition: .equal, from: .doneEntering2, to: .operationCompleted, performing: equalFunctionTwoOperands )

        machine.add(transition: .equal, from: .acceptedOperand1, to: .operationCompleted, performing: equalMissingSecondOperand )
        machine.add(transition: .equal, from: .acceptedOperand1Cleared, to: .operationCompleted, performing: equalMissingSecondOperand )

        let repeatedEqual: TransitionFunction<State, Transition> = { (machine, transition) in
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

        machine.add(transition: .equal, from: .operationCompleted, to: .operationCompleted, performing: repeatedEqual )

        // sequences
        let nextOperation: TransitionFunction<State, Transition> = { (machine, transition) in
            self.lastOperand = self.displayed
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

            if case let .calcOperator(oper) = transition {
                self.lastOperator = oper
                self.implicit = self.displayed
                self.lastOperand = nil
            }

        }

        for oper in ops {
            machine.add(transition: .calcOperator(oper), from: .entering2BeforePoint, to: .acceptedOperand1, performing: nextOperation )
            machine.add(transition: .calcOperator(oper), from: .entering2AfterPoint, to: .acceptedOperand1, performing: nextOperation )
            machine.add(transition: .calcOperator(oper), from: .operationCompleted, to: .acceptedOperand1, performing: acceptFirstOperand )
     }



        machine.add(transition: .digit(0), from: .operationCompleted, to: .nothingEntered3, performing: reset)
        machine.add(transition: .transformer(.signChange), from: .operationCompleted, to: .nothingEntered3Negative, performing: neToNeNeg)
        for i in 1 ... 9 {
            machine.add(transition: .digit(Double(i)), from: .operationCompleted, to: .entering3BeforePoint, performing: addFirstDigit)
        }
        machine.add(transition: .point, from: .operationCompleted, to: .entering3AfterPoint, performing: neToEAP)

        createNumberGatherer(ne: .nothingEntered3, neNeg: .nothingEntered3Negative, ebp: .entering3BeforePoint, eap: .entering3AfterPoint, done: .doneEntering, doneFunction: firstOperandPctFunction)

        // next calculation
        for oper in ops {
            machine.add(transition: .calcOperator(oper), from: .entering3BeforePoint, to: .acceptedOperand1, performing: acceptFirstOperand )
            machine.add(transition: .calcOperator(oper), from: .entering3AfterPoint, to: .acceptedOperand1, performing: acceptFirstOperand )
        }



////////////
        // =
//        let equalHelper = { () in
//            var answer: Double = 0
//            if let lastOp = self.lastOperator {
//                switch lastOp {
//                case .add:
//                    answer = self.implicit + self.displayed
//                case .subtract:
//                    answer = self.implicit - self.displayed
//                case .multiply:
//                    answer = self.implicit * self.displayed
//                case .divide:
//                    answer = self.implicit / self.displayed
//                }
//            }
//            self.displayAnswer(answer)
//        }
//
//
//        let equalFunctionChangingLastOperand: TransitionFunction<State, Transition> = { (machine, transition) in
//            if self.lastOperand == nil {
//                self.lastOperand = self.displayed
//            }
//            equalHelper()
//            self.implicit = self.lastOperand!
//        }
//
//
//
//
//        for oper in ops {
//            machine.add(transition: .calcOperator(oper), from: .doneEntering, to: .acceptedOperand1) { (machine, transition) in
//                self.lastOperator = oper
//                self.implicit = self.displayed
//                self.lastOperand = nil
//            }
//        }
//        machine.add(transition: .equal, from: .doneEntering2, to: .acceptedOperand1, performing: equalFunctionChangingLastOperand )


        // clear/all clear transitions
//        machine.add(transition: .clear, from: .enteringBeforePoint, to: .nothingEntered, performing: reset)
//        machine.add(transition: .clear, from: .enteringAfterPoint, to: .nothingEntered, performing: reset)
//        machine.add(transition: .clear, from: .acceptedOperand1, to: .acceptedOperand1Cleared, performing: clearSecondOperand)
//        machine.add(transition: .clear, from: .nothingEntered2, to: .acceptedOperand1Cleared, performing: clearSecondOperand)
//        machine.add(transition: .clear, from: .nothingEntered2Negative, to: .acceptedOperand1Cleared, performing: clearSecondOperand)
//        machine.add(transition: .clear, from: .entering2BeforePoint, to: .acceptedOperand1Cleared, performing: clearSecondOperand)
//        machine.add(transition: .clear, from: .entering2AfterPoint, to: .acceptedOperand1Cleared, performing: clearSecondOperand)

        // copy everything from .acceptedOperand1 to .acceptedOperand1Cleard with the exception of .clear


        // sequences of operations
//        for oper in ops {
//            machine.add(transition: .calcOperator(oper), from: .entering2BeforePoint, to: .acceptedOperand1, performing: nextOperation )
//            machine.add(transition: .calcOperator(oper), from: .entering2AfterPoint, to: .acceptedOperand1, performing: nextOperation )
//        }


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

