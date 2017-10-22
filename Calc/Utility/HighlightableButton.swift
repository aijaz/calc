//
//  HighlightableButton.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/22/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import UIKit

class HighlightableButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(hexString: "A0A0A0") : UIColor(hexString: "bebebe")
        }
    }

}
class OperatorButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(hexString: "ec8115") : UIColor(hexString: "FD9226")
        }
    }
}

class DigitButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(hexString: "b0b0b0") : UIColor(hexString: "d0d0d0")
        }
    }


}

