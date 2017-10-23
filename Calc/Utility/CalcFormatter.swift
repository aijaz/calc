//
//  CalcFormatter.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/19/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import Foundation

struct CalcFormatter {

    /// Scientific notation
    private static let scientificNumberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .scientific
        f.positiveFormat = "0.#####E00"
        f.negativeFormat = "0.#####E00"
        f.exponentSymbol = "e"

        return f
    }()

    /// 9 significant digits, with commas
    private static let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.usesSignificantDigits = true
        f.maximumSignificantDigits = 9
        f.numberStyle = .decimal
        f.positiveFormat = "#,##0.#0"
        f.negativeFormat = "#,##0.#0"

        return f
    }()

    /// Format a number in a way that's consistent with 's calculator app.
    /// - parameter number: The number to be formatted
    /// - returns: A string representation of the number
    /// - warning: The resulting string is for human consumption and will almost certainly not be parseable as a number
    static func string(for number: Double) -> String? {
        if Int(abs(number)+0.5) <= 999_999_999 {
            return numberFormatter.string(from: NSNumber(value: number))
        }
        else if abs(number) < 1e100 {
            return scientificNumberFormatter.string(from: NSNumber(value: number))
        }
        else {
            return nil
        }

    }
}


extension String {
    /// get all the digits in the string
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    /// return the number of digits in a string
    var numDigits: Int {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)[0].count
    }
}

