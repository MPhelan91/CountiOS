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

    func test_StringExtension_GetSubstringAfter() throws {
        let testCases:[(String,String,String?)] = [
            ("Total Fat 5g Saturated Fat 2g Protien 1g", "yup", nil),
            ("Total Fat 5g Saturated Fat 2g Protien 1g", "Fat", " 5g Saturated Fat 2g Protien 1g"),
            ("Total Fat 5g Saturated Fat 2g Protien 1g", "1g", ""),

        ]
        
        for testCase in testCases{
            let result = testCase.0.getSubstringAfter(testCase.1)
            XCTAssertEqual(result, testCase.2)
        }
    }
    
    func test_StringExtension_GetFirstIntegerValue() throws {
        let testCases:[(String,Int?)] = [
            ("There is no integer", nil),
            ("", nil),
            ("1", 1),
            ("Total Fat 1.2g Saturated Fat", 1),
            ("Total Fat (1.2g) Saturated Fat 1g", 1),
        ]
        
        for testCase in testCases{
            let result = testCase.0.getFirstIntegerValue()
            XCTAssertEqual(result, testCase.1)
        }
    }
    
    func test_StringExtension_GetFirstDecimalValue() throws {
        let testCases:[(String,Double?)] = [
            ("There is no decimal", nil),
            ("", nil),
            ("1", 1),
            ("Total Fat 1.2g Saturated Fat", 1.2),
            ("Total Fat (1.2g) Saturated Fat 1g", 1.2),
        ]
        
        for testCase in testCases{
            let result = testCase.0.getFirstDecimalValue()
            XCTAssertEqual(result, testCase.1)
        }
    }
    
    func test_StringExtension_GetServingInfo() throws {
        let testCases:[(String,(Int,Units)?)] = [
            ("There is no info", nil),
            ("yada yada serving size 1 pack(21g)", (21, Units.Gram)),
        ]
        
        for testCase in testCases{
            let result = testCase.0.getServingSizeInfo()
            if(testCase.1 == nil){
                XCTAssertTrue(result == nil)
            }
            else{
                XCTAssertEqual(result?.0, testCase.1?.0)
                XCTAssertEqual(result?.1, testCase.1?.1)
            }
        }
    }
    
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
