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
