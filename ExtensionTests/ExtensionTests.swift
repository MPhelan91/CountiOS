//
//  ExtensionTests.swift
//  ExtensionTests
//
//  Created by Michael Phelan on 8/16/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import XCTest
@testable import Count

class ExtensionTests: XCTestCase {

    func test_StringExtension_RoundDecimalString_Invalid() throws {
        let stringValue = "Hello"
        let result = stringValue.roundDecimalString(1)
        XCTAssertEqual(nil, result)
    }

    func test_StringExtension_RoundDecimalString_Valid() throws {
        let stringValue = "0.2235"
        let stringValue2 = "1.23004"
        
        let resultRoundDown = stringValue.roundDecimalString(2)
        XCTAssertEqual("0.22", resultRoundDown)
        
        let resultRoundUp = stringValue.roundDecimalString(3)
        XCTAssertEqual("0.224", resultRoundUp)
        
        let zero = stringValue.roundDecimalString(0)
        XCTAssertEqual("0", zero)
        
        let justIntegerValue = stringValue2.roundDecimalString(0)
        XCTAssertEqual("1", justIntegerValue)
        
        let removeTrailingZeroes = stringValue2.roundDecimalString(4)
        XCTAssertEqual("1.23", removeTrailingZeroes)
    }
    
    func test_FloatPintExtension_RoundDecimalString_Valid() throws {
        let numericValue = 0.2235
        let numericValue2 = 1.23004
        
        let resultRoundDown = numericValue.roundDecimalString(2)
        XCTAssertEqual("0.22", resultRoundDown)
        
        let resultRoundUp = numericValue.roundDecimalString(3)
        XCTAssertEqual("0.224", resultRoundUp)
        
        let zero = numericValue.roundDecimalString(0)
        XCTAssertEqual("0", zero)
        
        let justIntegerValue = numericValue2.roundDecimalString(0)
        XCTAssertEqual("1", justIntegerValue)
        
        let removeTrailingZeroes = numericValue2.roundDecimalString(4)
        XCTAssertEqual("1.23", removeTrailingZeroes)
    }
}
