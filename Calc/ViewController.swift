//
//  ViewController.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/19/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var acButton: HighlightableButton!
    @IBOutlet var signChangeButton: HighlightableButton!
    @IBOutlet var pctButton: HighlightableButton!
    @IBOutlet var divideButton: OperatorButton!
    @IBOutlet var multiplyButton: OperatorButton!
    @IBOutlet var subtractButton: OperatorButton!
    @IBOutlet var addButton: OperatorButton!
    @IBOutlet var equalButton: OperatorButton!
    @IBOutlet var digit0: DigitButton!
    @IBOutlet var digit1: DigitButton!
    @IBOutlet var point: UIButton!
    @IBOutlet var digit2: DigitButton!
    @IBOutlet var digit3: DigitButton!
    @IBOutlet var digit4: DigitButton!
    @IBOutlet var digit5: DigitButton!
    @IBOutlet var digit6: DigitButton!
    @IBOutlet var digit7: DigitButton!
    @IBOutlet var digit8: DigitButton!
    @IBOutlet var digit9: DigitButton!
    @IBOutlet var strLabel: UILabel!
    @IBOutlet var acLabel: UILabel!

    let calculator = Calculator()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        acButton.backgroundColor = UIColor(hexString: "bebebe")
        signChangeButton.backgroundColor = UIColor(hexString: "bebebe")
        pctButton.backgroundColor = UIColor(hexString: "bebebe")
        divideButton.backgroundColor = UIColor(hexString: "FD9226")
        subtractButton.backgroundColor = UIColor(hexString: "FD9226")
        multiplyButton.backgroundColor = UIColor(hexString: "FD9226")
        addButton.backgroundColor = UIColor(hexString: "FD9226")
        equalButton.backgroundColor = UIColor(hexString: "FD9226")
        point.backgroundColor = UIColor(hexString: "d0d0d0")
        digit0.backgroundColor = UIColor(hexString: "d0d0d0")
        digit1.backgroundColor = UIColor(hexString: "d0d0d0")
        digit2.backgroundColor = UIColor(hexString: "d0d0d0")
        digit3.backgroundColor = UIColor(hexString: "d0d0d0")
        digit4.backgroundColor = UIColor(hexString: "d0d0d0")
        digit5.backgroundColor = UIColor(hexString: "d0d0d0")
        digit6.backgroundColor = UIColor(hexString: "d0d0d0")
        digit7.backgroundColor = UIColor(hexString: "d0d0d0")
        digit8.backgroundColor = UIColor(hexString: "d0d0d0")
        digit9.backgroundColor = UIColor(hexString: "d0d0d0")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func shouldShowAC() -> Bool {
        if calculator.machine.state == .nothingEntered ||
        calculator.machine.state == .nothingEntered2 ||
            calculator.machine.state == .acceptedOperand1Cleared {
            return true
        }
        return false
    }


    @IBAction func handleButtonTap(_ sender: UIButton) {
        if (sender == digit0) { calculator.keyPressed(.digit(0)) }
        else if (sender == digit1) { calculator.keyPressed(.digit(1)) }
        else if (sender == digit2) { calculator.keyPressed(.digit(2)) }
        else if (sender == digit3) { calculator.keyPressed(.digit(3)) }
        else if (sender == digit4) { calculator.keyPressed(.digit(4)) }
        else if (sender == digit5) { calculator.keyPressed(.digit(5)) }
        else if (sender == digit6) { calculator.keyPressed(.digit(6)) }
        else if (sender == digit7) { calculator.keyPressed(.digit(7)) }
        else if (sender == digit8) { calculator.keyPressed(.digit(8)) }
        else if (sender == digit9) { calculator.keyPressed(.digit(9)) }
        else if (sender == point) { calculator.keyPressed(.point) }
        else if (sender == equalButton) { calculator.keyPressed(.equal) }
        else if (sender == addButton) { calculator.keyPressed(.calcOperator(.add)) }
        else if (sender == subtractButton) { calculator.keyPressed(.calcOperator(.subtract)) }
        else if (sender == multiplyButton) { calculator.keyPressed(.calcOperator(.multiply)) }
        else if (sender == divideButton) { calculator.keyPressed(.calcOperator(.divide)) }
        else if (sender == signChangeButton) { calculator.keyPressed(.transformer(.signChange)) }
        else if (sender == pctButton) { calculator.keyPressed(.transformer(.percent)) }
        else if (sender == acButton) {
            if self.shouldShowAC() {
                calculator.keyPressed(.allClear)
            }
            else {
                calculator.keyPressed(.clear)
            }
        }
        self.refresh()
    }

    func refresh() {
        strLabel.text = calculator.str
        if self.shouldShowAC() {
            acLabel.text = "AC"
        }
        else {
            acLabel.text = "C"
        }
    }


}

