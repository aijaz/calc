//
//  CalcFormatter.swift
//  Calc
//
//  Created by Aijaz Ansari on 10/19/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import Foundation

struct CalcFormatter {

    
    private static let scientificNumberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .scientific
        f.positiveFormat = "0.#####E00"
        f.negativeFormat = "0.#####E00"
        f.exponentSymbol = "e"

        return f
    }()

    private static let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.usesSignificantDigits = true
        f.maximumSignificantDigits = 9
        f.numberStyle = .decimal
        f.positiveFormat = "#,##0.#0"
        f.negativeFormat = "#,##0.#0"

        return f
    }()

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
