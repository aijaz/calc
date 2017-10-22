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


}

