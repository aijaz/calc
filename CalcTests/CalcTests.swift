//
//  CalcTests.swift
//  CalcTests
//
//  Created by Aijaz Ansari on 10/19/17.
//  Copyright © 2017 Aijaz Ansari. All rights reserved.
//

import XCTest
@testable import Calc

class CalcTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFormat() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        assertNumber(1, "1")
        assertNumber(0, "0")
        assertNumber(-1, "-1")
        assertNumber(123456789, "123,456,789")
        assertNumber(-123456789, "-123,456,789")
        assertNumber(999_999_999, "999,999,999")
        assertNumber(-999_999_999, "-999,999,999")

        assertNumber(1.5, "1.5")
        assertNumber(0.5, "0.5")
        assertNumber(-1.5, "-1.5")
        assertNumber(123456789.4, "123,456,789")
        assertNumber(-123456789.4, "-123,456,789")
        assertNumber(999_999_999.4, "999,999,999")
        assertNumber(-999_999_999.4, "-999,999,999")
        assertNumber(123456789.5, "123,456,790")
        assertNumber(-123456789.5, "-123,456,790")

        assertNumber(999_999_999.5, "1e09")
        assertNumber(-999_999_999.5, "-1e09")


    }

    func testNumberEntry() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")

        c.keyPressed(.digit(2))
        XCTAssert(c.displayed == 12)
        XCTAssert(c.str == "12")

        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 123)
        XCTAssert(c.str == "123")
        
        c.keyPressed(.point)
        XCTAssert(c.displayed == 123)
        XCTAssert(c.str == "123.")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 123.4)
        XCTAssert(c.str == "123.4")

        c.keyPressed(.point)
        XCTAssert(c.displayed == 123.4)
        XCTAssert(c.str == "123.4")

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 123.4)
        XCTAssert(c.str == "123.40")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 123.404)
        XCTAssert(c.str == "123.404")
    }

    func testStartingWithPoint() {
        let c = Calculator()

        c.keyPressed(.point)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0.")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 0.4)
        XCTAssert(c.str == "0.4")

    }

    func testStartingWithZero() {
        let c = Calculator()

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")

        c.keyPressed(.digit(2))
        XCTAssert(c.displayed == 12)
        XCTAssert(c.str == "12")

        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 123)
        XCTAssert(c.str == "123")

        c.keyPressed(.point)
        XCTAssert(c.displayed == 123)
        XCTAssert(c.str == "123.")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 123.4)
        XCTAssert(c.str == "123.4")

        c.keyPressed(.point)
        XCTAssert(c.displayed == 123.4)
        XCTAssert(c.str == "123.4")

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 123.4)
        XCTAssert(c.str == "123.40")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 123.404)
        XCTAssert(c.str == "123.404")
    }

    func testStartingWithZeroPoint() {
        let c = Calculator()

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.point)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0.")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 0.4)
        XCTAssert(c.str == "0.4")

    }

    func testStartingWithZeroZeroPoint() {
        let c = Calculator()

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.point)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0.")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 0.4)
        XCTAssert(c.str == "0.4")

    }

    func testMultiplePoint() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")

        c.keyPressed(.digit(2))
        XCTAssert(c.displayed == 12)
        XCTAssert(c.str == "12")

        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 123)
        XCTAssert(c.str == "123")

        c.keyPressed(.point)
        XCTAssert(c.displayed == 123)
        XCTAssert(c.str == "123.")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 123.4)
        XCTAssert(c.str == "123.4")

        c.keyPressed(.point)
        XCTAssert(c.displayed == 123.4)
        XCTAssert(c.str == "123.4")

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 123.4)
        XCTAssert(c.str == "123.40")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 123.404)
        XCTAssert(c.str == "123.404")

        c.keyPressed(.point)
        XCTAssert(c.displayed == 123.404)
        XCTAssert(c.str == "123.404")

        c.keyPressed(.digit(9))
        XCTAssert(c.displayed == 123.4049)
        XCTAssert(c.str == "123.4049")


    }

    func testZeroZero() {
        let c = Calculator()

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
    }

    func testTwoOperandAdd() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.calcOperator(.add))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 15)
        XCTAssert(c.str == "15")
    }

    func testMissingSecondOperand() {
        let c = Calculator()

        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
        c.keyPressed(.calcOperator(.add))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 6)
        XCTAssert(c.str == "6")
    }

    func testMissingSecondOperandMultipleEqual() {
        let c = Calculator()

        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
        c.keyPressed(.calcOperator(.add))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 6)
        XCTAssert(c.str == "6")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 9)
        XCTAssert(c.str == "9")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 12)
        XCTAssert(c.str == "12")
    }

    func testMissingSecondOperandMultipleEqualSubtract() {
        let c = Calculator()

        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
        c.keyPressed(.calcOperator(.subtract))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == -3)
        XCTAssert(c.str == "-3")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == -6)
        XCTAssert(c.str == "-6")
    }

    func testAdd() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.calcOperator(.add))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 15)
        XCTAssert(c.str == "15")

        c.keyPressed(.calcOperator(.add))
        XCTAssert(c.displayed == 15)
        XCTAssert(c.str == "15")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 30)
        XCTAssert(c.str == "30")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 45)
        XCTAssert(c.str == "45")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 60)
        XCTAssert(c.str == "60")

    }

    func testImplicit() {
        let c = Calculator()

        c.keyPressed(.digit(3))
        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 6)
        XCTAssert(c.str == "6")

        c.keyPressed(.digit(2))
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.digit(4))
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 7)
        XCTAssert(c.str == "7")

        c.keyPressed(.digit(4))
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 7)
        XCTAssert(c.str == "7")


        c.keyPressed(.digit(5))
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")

        c.keyPressed(.digit(9))
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 12)
        XCTAssert(c.str == "12")

    }

    func testRepeated() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.calcOperator(.add))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 15)
        XCTAssert(c.str == "15")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 20)
        XCTAssert(c.str == "20")
    }

    func testDecimalRepeated() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")
        c.keyPressed(.point)
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1.")
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 1.5)
        XCTAssert(c.str == "1.5")
        c.keyPressed(.calcOperator(.add))
        XCTAssert(c.displayed == 1.5)
        XCTAssert(c.str == "1.5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 4.5)
        XCTAssert(c.str == "4.5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 6)
        XCTAssert(c.str == "6")

    }

    func testMultiplicationRepeated() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.calcOperator(.multiply))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 25)
        XCTAssert(c.str == "25")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 125)
        XCTAssert(c.str == "125")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 625)
        XCTAssert(c.str == "625")

    }

    func testSubtractionRepeated() {
        let c = Calculator()

        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.calcOperator(.subtract))
        c.keyPressed(.digit(2))
        XCTAssert(c.displayed == 2)
        XCTAssert(c.str == "2")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 6)
        XCTAssert(c.str == "6")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 4)
        XCTAssert(c.str == "4")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 2)
        XCTAssert(c.str == "2")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == -2)
        XCTAssert(c.str == "-2")

    }

    func testMultipleNumberAddition() {
        let c = Calculator()

        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.digit(2))
        XCTAssert(c.displayed == 82)
        XCTAssert(c.str == "82")
        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.digit(2))
        XCTAssert(c.displayed == 82)
        XCTAssert(c.str == "82")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 164)
        XCTAssert(c.str == "164")

    }

    func testNegZero() {
        let c = Calculator()

        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "-0")

        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")
    }

    func testSignChangeFirstOperand1Digit1Digit() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == -5)
        XCTAssert(c.str == "-5")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
    }

    func testSignChangeFirstOperand1Digit1DigitPre() {
        let c = Calculator()

        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == -5)
        XCTAssert(c.str == "-5")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
    }

    func testSignChangeFirstOperand1Digit1DigitPreMultOdd() {
        let c = Calculator()

        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == -5)
        XCTAssert(c.str == "-5")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")
    }

    func testSignChangeFirstOperand1Digit1DigitPreMultEven() {
        let c = Calculator()

        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 13)
        XCTAssert(c.str == "13")
    }


    func testSignChangeSecondOperand1Digit1Digit() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.equal)
        XCTAssert(c.displayed == -3)
        XCTAssert(c.str == "-3")
    }

    func testSignChangeSecondOperand1Digit1DigitPre() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == -8)
        XCTAssert(c.str == "-8")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == -3)
        XCTAssert(c.str == "-3")
    }

    func testSignChangeSecondOperand1Digit1DigitPreMultOdd() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == -8)
        XCTAssert(c.str == "-8")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == -3)
        XCTAssert(c.str == "-3")
    }

    func testSignChangeSecondOperand1Digit1DigitPreMultEven() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 13)
        XCTAssert(c.str == "13")
    }

    func testNE2NegPoint() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "-0")
        c.keyPressed(.point)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "-0.")

    }

    func testPercentageNEN_NE() {
        let c = Calculator()

        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.transformer(.percent))
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")
    }

    func testPctFirstOperand() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 55)
        XCTAssert(c.str == "55")
        c.keyPressed(.transformer(.percent))
        XCTAssert(c.displayed == 0.55)
        XCTAssert(c.str == "0.55")
        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 8.55)
        XCTAssert(c.str == "8.55")
    }

    func testPctSecondOperandEqual() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 8)
        XCTAssert(c.str == "8")
        c.keyPressed(.digit(8))
        XCTAssert(c.displayed == 88)
        XCTAssert(c.str == "88")
        c.keyPressed(.transformer(.percent))
        XCTAssert(c.displayed == 4.4)
        XCTAssert(c.str == "4.4")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 9.4)
        XCTAssert(c.str == "9.4")


    }

    func testPctSecondOperandEqualRepeatedly() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 55)
        XCTAssert(c.str == "55")
        c.keyPressed(.transformer(.percent))
        XCTAssert(c.displayed == 5.5)
        XCTAssert(c.str == "5.5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 15.5)
        XCTAssert(c.str == "15.5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 21)
        XCTAssert(c.str == "21")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 26.5)
        XCTAssert(c.str == "26.5")

    }

    func testClearEnteringFirstOperand() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

    }

    func testClearEnteringFirstOperandPoint() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.point)
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 10.5)
        XCTAssert(c.str == "10.5")
        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

    }

    func testClearEnteringFirstOperandPointNegative() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.point)
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 10.5)
        XCTAssert(c.str == "10.5")
        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == -10.5)
        XCTAssert(c.str == "-10.5")
        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")
    }

    func testClearEnteringFirstOperandPointNegative2() {
        let c = Calculator()
        
        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.point)
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 10.5)
        XCTAssert(c.str == "10.5")
        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == -10.5)
        XCTAssert(c.str == "-10.5")
        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == 10.5)
        XCTAssert(c.str == "10.5")
        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")
    }

    func testClearEnteringFirstOperandPointNegative3() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")
        c.keyPressed(.digit(0))
        XCTAssert(c.displayed == 10)
        XCTAssert(c.str == "10")
        c.keyPressed(.point)
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 10.5)
        XCTAssert(c.str == "10.5")
        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == -10.5)
        XCTAssert(c.str == "-10.5")
        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == 10.5)
        XCTAssert(c.str == "10.5")
        c.keyPressed(.transformer(.signChange))
        XCTAssert(c.displayed == -10.5)
        XCTAssert(c.str == "-10.5")
        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")
    }

    func testClear2ndOperandNE2() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 6)
        XCTAssert(c.str == "6")

    }

    func testClear2ndOperandNE2Neg() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.transformer(.signChange))
        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 6)
        XCTAssert(c.str == "6")

    }

    func testClear2ndOperandE2BP() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 4)
        XCTAssert(c.str == "4")
        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 6)
        XCTAssert(c.str == "6")

    }

    func testClear2ndOperandE2AP() {
        let c = Calculator()

        c.keyPressed(.digit(1))
        XCTAssert(c.displayed == 1)
        XCTAssert(c.str == "1")

        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 4)
        XCTAssert(c.str == "4")
        c.keyPressed(.point)
        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 4.5)
        XCTAssert(c.str == "4.5")
        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")
        c.keyPressed(.equal)
        XCTAssert(c.displayed == 6)
        XCTAssert(c.str == "6")

    }

    func testAC() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.multiply))
        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 15)
        XCTAssert(c.str == "15")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 45)
        XCTAssert(c.str == "45")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 135)
        XCTAssert(c.str == "135")

        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 4)
        XCTAssert(c.str == "4")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 12)
        XCTAssert(c.str == "12")

        c.keyPressed(.clear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.allClear)
        XCTAssert(c.displayed == 0)
        XCTAssert(c.str == "0")

        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 4)
        XCTAssert(c.str == "4")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 4)
        XCTAssert(c.str == "4")
    }

    func testSequence() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.multiply))
        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")

        c.keyPressed(.calcOperator(.multiply))
        XCTAssert(c.displayed == 15)
        XCTAssert(c.str == "15")
        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 45)
        XCTAssert(c.str == "45")

    }

    func testSequenceWithEqual() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.multiply))
        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 15)
        XCTAssert(c.str == "15")
        c.keyPressed(.calcOperator(.add))
        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 18)
        XCTAssert(c.str == "18")

    }



    func testNextOperation() {
        let c = Calculator()

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.multiply))
        c.keyPressed(.digit(3))
        XCTAssert(c.displayed == 3)
        XCTAssert(c.str == "3")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 15)
        XCTAssert(c.str == "15")

        c.keyPressed(.digit(5))
        XCTAssert(c.displayed == 5)
        XCTAssert(c.str == "5")

        c.keyPressed(.calcOperator(.multiply))
        c.keyPressed(.digit(4))
        XCTAssert(c.displayed == 4)
        XCTAssert(c.str == "4")

        c.keyPressed(.equal)
        XCTAssert(c.displayed == 20)
        XCTAssert(c.str == "20")


    }

    func assertNumber(_ number: Double, _ str: String?) {
        let s = CalcFormatter.string(for: number)
        NSLog("Testing \(number) Got '\(s ?? "nil")', expected \(str ?? "nil")")
        XCTAssert(s == str)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
