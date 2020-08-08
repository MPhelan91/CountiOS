//
//  Conversions.swift
//  Count
//
//  Created by Michael Phelan on 8/4/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation

struct UnitKey: Hashable{
    var fromUnit:ServingUnit
    var toUnit:ServingUnit
    init(from:ServingUnit, to:ServingUnit){
        fromUnit = from
        toUnit = to
    }
}

class Conversions{
    private static var massAndWeightUnits = [ServingUnit.Gram, ServingUnit.Ounce, ServingUnit.Pound]
    private static var volumeUnits = [ServingUnit.Cup, ServingUnit.Milliliter, ServingUnit.Liter]
    
    private static var unitConversionDictionary = [
        UnitKey(from:ServingUnit.Liter, to:ServingUnit.Milliliter): 1000,
        UnitKey(from:ServingUnit.Milliliter, to:ServingUnit.Liter): 0.001,
        
        UnitKey(from:ServingUnit.Liter, to:ServingUnit.Cup): 4.22675,
        UnitKey(from:ServingUnit.Cup, to:ServingUnit.Liter): 0.236588,
        
        UnitKey(from:ServingUnit.Cup, to:ServingUnit.Milliliter): 236.588,
        UnitKey(from:ServingUnit.Milliliter, to:ServingUnit.Cup): 0.00422675,
        
        UnitKey(from:ServingUnit.Gram, to:ServingUnit.Ounce): 0.035274,
        UnitKey(from:ServingUnit.Ounce, to:ServingUnit.Gram): 28.3495,
        
        UnitKey(from:ServingUnit.Gram, to:ServingUnit.Pound): 0.00220462,
        UnitKey(from:ServingUnit.Pound, to:ServingUnit.Gram): 453.592,
        
        UnitKey(from:ServingUnit.Pound, to:ServingUnit.Ounce): 16,
        UnitKey(from:ServingUnit.Ounce, to:ServingUnit.Pound): 0.0625,
    ]
    
    public static func Convert(servingSize:ServingInfo, servingNutrition: NutritionalInfo, portion:ServingInfo) throws -> NutritionalInfo {
        let ratio = servingSize.Unit == portion.Unit
            ? portion.Serving / servingSize.Serving
            : try ConvertPortion(portion: portion, servingUnit: servingSize.Unit) / servingSize.Serving
        
        return NutritionalInfo(calories: servingNutrition.Calories * ratio, protien: servingNutrition.Protien * ratio);
    }
    
    public static func ConvertPortion(portion:ServingInfo, servingUnit:ServingUnit) throws -> Double {
        if((volumeUnits.contains(portion.Unit) && massAndWeightUnits.contains(servingUnit)) ||
            (massAndWeightUnits.contains(portion.Unit) && volumeUnits.contains(servingUnit)) ){
            throw CountError.VolumeMassConversion
        }
        
        let ratio = unitConversionDictionary[UnitKey(from:portion.Unit, to:servingUnit)]
        return ratio! * portion.Serving;
    }
}
