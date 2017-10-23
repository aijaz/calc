//
//  HighlightableButton.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/22/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import UIKit

/// A subclass of UIButton whose background color changes when highlighted. Used for the AC/C, +/-, and % buttons
class HighlightableButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(hexString: "A0A0A0") : UIColor(hexString: "bebebe")
        }
    }

}

/// A subclass of UIButton whose background color changes when highlighted. Used for the +, -, ×, and ÷ buttons
class OperatorButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(hexString: "ec8115") : UIColor(hexString: "FD9226")
        }
    }
}

/// A subclass of UIButton whose background color changes when highlighted. Used for the digit buttons
class DigitButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(hexString: "b0b0b0") : UIColor(hexString: "d0d0d0")
        }
    }


}

