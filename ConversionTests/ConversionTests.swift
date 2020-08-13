//
//  ConversionTests.swift
//  ConversionTests
//
//  Created by Michael Phelan on 8/10/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import XCTest
@testable import Count

class ConversionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConvertPortion_Exception() throws {
        let cases : [(Units,Units)] = [(Units.Pound, Units.Cup),
                                       (Units.Pound, Units.Liter),
                                       (Units.Pound, Units.Milliliter),
                                       (Units.Gram, Units.Cup),
                                       (Units.Gram, Units.Liter),
                                       (Units.Gram, Units.Milliliter),
                                       (Units.Ounce, Units.Cup),
                                       (Units.Ounce, Units.Liter),
                                       (Units.Ounce, Units.Milliliter)]
        
        for testCase in cases{
            XCTAssertThrowsError(try Conversions.ConvertPortion(portion: 1, fromUnit: testCase.0, toUnit: testCase.1)) { error in
                XCTAssertEqual(error as! CountError, CountError.VolumeMassConversion)
            }
            XCTAssertThrowsError(try Conversions.ConvertPortion(portion: 1, fromUnit: testCase.1, toUnit: testCase.0)) { error in
                XCTAssertEqual(error as! CountError, CountError.VolumeMassConversion)
            }
        }
    }
    
    func testConvert() throws{
        let cases = [
            (NutritionalInfo(1,4,Units.Ounce,110,26),
             NutritionalInfo(3,12,Units.Ounce,330,78)),
            
            (NutritionalInfo(1,4,Units.Ounce,110,26),
             NutritionalInfo(5,1.25,Units.Pound,550,130)),
            
            (NutritionalInfo(1,0.75,Units.Pound,100,5),
             NutritionalInfo(1.175797,400,Units.Gram,117.579733,5.87898667)),
            
            (NutritionalInfo(1,1,Units.Liter,30,3),
             NutritionalInfo(2.5,2500,Units.Milliliter,75,7.5)),
            
            (NutritionalInfo(1,1,Units.Cup,30,3),
             NutritionalInfo(4.22675,1,Units.Liter,126.8025,12.68025)),
            
            (NutritionalInfo(1,1,Units.Cup,30,3),
             NutritionalInfo(4.22675,1000,Units.Milliliter,126.8025,12.68025))
        ]
        
        for testCase in cases{
            let definition = testCase.0
            let expectedResult = testCase.1
            
            for dataChanged in ChangedData.allCases{
                let result = try Conversions.Convert(definition: definition, fieldChanged: dataChanged, newValue: enumToValue(dataChanged, expectedResult), newUnit: expectedResult.PortionUnit)
                XCTAssertEqual(expectedResult.PortionSize, result.PortionSize, accuracy: 0.01)
                XCTAssertEqual(expectedResult.PortionUnit, result.PortionUnit)
                XCTAssertEqual(expectedResult.Calories, result.Calories, accuracy: 0.01)
                XCTAssertEqual(expectedResult.Protien, result.Protien, accuracy: 0.01)
                XCTAssertEqual(expectedResult.NumberOfServings, result.NumberOfServings, accuracy: 0.01)
                
                let definition2 = try Conversions.Convert(definition: result, fieldChanged: dataChanged, newValue: enumToValue(dataChanged, definition), newUnit: definition.PortionUnit);
                XCTAssertEqual(definition.PortionSize, definition2.PortionSize, accuracy: 0.01)
                XCTAssertEqual(definition.PortionUnit, definition2.PortionUnit)
                XCTAssertEqual(definition.Calories, definition2.Calories, accuracy: 0.01)
                XCTAssertEqual(definition.Protien, definition2.Protien, accuracy: 0.01)
                XCTAssertEqual(definition.NumberOfServings, definition2.NumberOfServings, accuracy: 0.01)
            }
        }
    }
    
    private func enumToValue(_ fieldChanged: ChangedData, _ data : NutritionalInfo) -> Double {
        switch fieldChanged {
        case ChangedData.NumberOfServings:
            return data.NumberOfServings
        case ChangedData.Portion:
            return data.PortionSize
        case ChangedData.Calorie:
            return data.Calories
        case ChangedData.Protien:
            return data.Protien
        }
    }
}

