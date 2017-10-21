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
    case enteringBeforePoint
    case enteringAfterPoint
    case acceptedOperand1
    case nothingEntered2
    case entering2BeforePoint
    case entering2AfterPoint
    case primed
    case acceptedOperand2
}




class Calculator {
    var saved: Double
    var pointEntered: Bool
    var numFractionalDigits: Int
    var str: String
    var plainStr: String
    var displayed: Double
    var entered: Double {
        return Double(str)!
    }
    var lastOp: CalcOperator?

    let machine = StateMachine<State, Transition>(state: .nothingEntered)

    init() {
        saved = 0
        displayed = 0
        pointEntered = false
        numFractionalDigits = 0
        str = "0"
        plainStr = "0"

        for i in 1 ... 9 {
            NSLog("i is \(i)")
            machine.add(transition: .digit(Double(i)), from: .nothingEntered, to: .enteringBeforePoint) { (machine, transition) in
                self.str = "\(i)"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
        }
        machine.add(transition: .point, from: .nothingEntered, to: .enteringAfterPoint) { (machine, transition) in
            self.plainStr = "\(self.plainStr)."
            self.str = "\(self.str)."
            self.displayed = Double(self.plainStr)!
        }
        for i in 0 ... 9 {
            NSLog("i is \(i)")
            machine.add(transition: .digit(Double(i)), from: .enteringBeforePoint, to: .enteringBeforePoint) { (machine, transition) in
                let tempStr = "\(self.plainStr)\(i)"
                if tempStr.numDigits <= 9 {
                    self.plainStr = tempStr
                    self.str = CalcFormatter.string(for: Double(self.plainStr)!)!
                    self.displayed = Double(self.plainStr)!
                }
            }
        }
        machine.add(transition: .point, from: .enteringBeforePoint, to: .enteringAfterPoint) { (machine, transition) in
            self.plainStr = "\(self.plainStr)."
            self.str = "\(self.str)."
            self.displayed = Double(self.plainStr)!
        }
        for i in 0 ... 9 {
            machine.add(transition: .digit(Double(i)), from: .enteringAfterPoint, to: .enteringAfterPoint) { (machine, transition) in
                let tempStr = "\(self.plainStr)\(i)"
                if tempStr.numDigits <= 9 {
                    self.str = "\(self.str)\(i)"
                    self.plainStr = "\(self.plainStr)\(i)"
                    self.displayed = Double(self.plainStr)!
                }
            }
        }

        let ops: [CalcOperator] = [.add, .subtract, .multiply, .divide]
        for oper in ops {
            machine.add(transition: .calcOperator(oper), from: .enteringBeforePoint, to: .acceptedOperand1) { (machine, transition) in
                self.lastOp = oper
                self.saved = self.displayed
            }
            machine.add(transition: .calcOperator(oper), from: .enteringAfterPoint, to: .acceptedOperand1) { (machine, transition) in
                self.lastOp = oper
                self.saved = self.displayed
            }
        }
        machine.add(transition: .digit(0), from: .acceptedOperand1, to: .nothingEntered2) { (machine, transition) in
            self.str = "0"
            self.plainStr = self.str
            self.displayed = Double(self.plainStr)!
        }
        for i in 1 ... 9 {
            NSLog("i is \(i)")
            machine.add(transition: .digit(Double(i)), from: .acceptedOperand1, to: .entering2BeforePoint) { (machine, transition) in
                self.str = "\(i)"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
            machine.add(transition: .digit(Double(i)), from: .nothingEntered2, to: .entering2BeforePoint) { (machine, transition) in
                self.str = "\(i)"
                self.plainStr = self.str
                self.displayed = Double(self.plainStr)!
            }
        }
        machine.add(transition: .point, from: .acceptedOperand1, to: .entering2AfterPoint) { (machine, transition) in
            self.plainStr = "0."
            self.str = "0."
            self.displayed = Double(self.plainStr)!
        }
        machine.add(transition: .point, from: .nothingEntered2, to: .entering2AfterPoint) { (machine, transition) in
            self.plainStr = "\(self.plainStr)."
            self.str = "\(self.str)."
            self.displayed = Double(self.plainStr)!
        }


        // =
        machine.add(transition: .equal, from: .entering2BeforePoint, to: .acceptedOperand1) { (machine, transition) in
            var answer: Double = 0
            if let lastOp = self.lastOp {
                switch lastOp {
                case .add:
                    answer = self.saved + self.displayed
                case .subtract:
                    answer = self.saved - self.displayed
                case .multiply:
                    answer = self.saved * self.displayed
                case .divide:
                    answer = self.saved / self.displayed
                }
            }
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




//        let digitFunction: TransitionFunction<State, Transition> = { (machine, transition) in
//            if case let Transition.digit(digit) = transition {
//                NSLog("Transitioning with \(digit)")
//                if self.pointEntered {
//                    self.numFractionalDigits += 1
//                    var multiplicant:Double = 1.0
//                    for _ in 0 ..< self.numFractionalDigits {
//                        multiplicant *= Double(0.1)
//                    }
//                    self.displayed += (digit * multiplicant)
//                }
//                else {
//                    self.displayed = self.displayed * 10 + digit
//                }
//            }
//        }
//
//        for i in 1 ... 9 {
//            NSLog("i is \(i)")
//            machine.add(transition: .digit(Double(i)), from: .nothingEntered, to: .entering, performing: digitFunction)
//        }
//        for i in 0 ... 9 {
//            NSLog("i is \(i)")
//            machine.add(transition: .digit(Double(i)), from: .entering, to: .entering, performing: digitFunction)
//        }
//
//        let pointFunction: TransitionFunction<State, Transition> = { (machine, transition) in
//            if self.pointEntered { return }
//            self.pointEntered = true
//
//        }
//        machine.add(transition: .point, from: .nothingEntered, to: .entering, performing: pointFunction)
//        machine.add(transition: .point, from: .entering, to: .entering, performing: pointFunction)


    }

    func keyPressed(_ transition: Transition) {
        machine.perform(transition: transition)
    }
}

