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

    func testConversions() throws {
        let cases = [(4, Units.Ounce, 110.0, 26.0,
                      12, Units.Ounce, 330.0, 78.0),
                     
                     (4 , Units.Ounce, 110.0, 26.0,
                      1.25, Units.Pound, 550.0, 130.0),
        
                     (0.75 , Units.Pound, 100.0, 5.0,
                      400, Units.Gram, 117.58, 5.88),
                     
                     (1 , Units.Liter, 30.0, 3.0,
                      2500, Units.Milliliter, 75.0, 7.5),
                     
                     (1 , Units.Cup, 30.0, 3.0,
                      1, Units.Liter, 126.80, 12.68),
                     
                     (1 , Units.Cup, 30.0, 3.0,
                      1000, Units.Milliliter, 126.80, 12.68)]
        
        for testCase in cases{
            let fromServing = ServingInfo(Serving: testCase.0, ServingUnit: testCase.1)
            let fromInfo = NutritionalInfo(Calories: testCase.2, Protien: testCase.3)
            let toServing = ServingInfo(Serving: testCase.4, ServingUnit: testCase.5)
            
            let toInfo = try Conversions.Convert(servingSize: fromServing, servingNutrition: fromInfo, portion: toServing)
            XCTAssertEqual(testCase.6, toInfo.Calories, accuracy: 0.01)
            XCTAssertEqual(testCase.7, toInfo.Protien, accuracy: 0.01)
            //
            let fromInfo2 = try Conversions.Convert(servingSize: toServing, servingNutrition: toInfo, portion: fromServing);
            XCTAssertEqual(fromInfo.Calories, fromInfo2.Calories, accuracy: 0.01)
            XCTAssertEqual(fromInfo.Protien, fromInfo2.Protien, accuracy: 0.01)
        }
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
}

