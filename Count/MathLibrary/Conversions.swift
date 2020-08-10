//
//  Conversions.swift
//  Count
//
//  Created by Michael Phelan on 8/4/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation

struct UnitKey: Hashable{
    var fromUnit:Units
    var toUnit:Units
    init(from:Units, to:Units){
        fromUnit = from
        toUnit = to
    }
}

class Conversions{
    private static var massAndWeightUnits = [Units.Gram, Units.Ounce, Units.Pound]
    private static var volumeUnits = [Units.Cup, Units.Milliliter, Units.Liter]
    
    private static var unitConversionDictionary = [
        UnitKey(from:Units.Liter, to:Units.Milliliter): 1000,
        UnitKey(from:Units.Milliliter, to:Units.Liter): 0.001,
        
        UnitKey(from:Units.Liter, to:Units.Cup): 4.22675,
        UnitKey(from:Units.Cup, to:Units.Liter): 0.236588,
        
        UnitKey(from:Units.Cup, to:Units.Milliliter): 236.588,
        UnitKey(from:Units.Milliliter, to:Units.Cup): 0.00422675,
        
        UnitKey(from:Units.Gram, to:Units.Ounce): 0.035274,
        UnitKey(from:Units.Ounce, to:Units.Gram): 28.3495,
        
        UnitKey(from:Units.Gram, to:Units.Pound): 0.00220462,
        UnitKey(from:Units.Pound, to:Units.Gram): 453.592,
        
        UnitKey(from:Units.Pound, to:Units.Ounce): 16,
        UnitKey(from:Units.Ounce, to:Units.Pound): 0.0625,
    ]
    
    public static func Convert(servingSize:ServingInfo, servingNutrition: NutritionalInfo, portion:ServingInfo) throws -> NutritionalInfo {
        let ratio = servingSize.ServingUnit == portion.ServingUnit
            ? portion.Serving / servingSize.Serving
            : try ConvertPortion(portion: portion, servingUnit: servingSize.ServingUnit) / servingSize.Serving
        
        return NutritionalInfo(Calories: servingNutrition.Calories * ratio, Protien: servingNutrition.Protien * ratio);
    }
    
    public static func ConvertPortion(portion:ServingInfo, servingUnit:Units) throws -> Double {
        if((volumeUnits.contains(portion.ServingUnit) && massAndWeightUnits.contains(servingUnit)) ||
            (massAndWeightUnits.contains(portion.ServingUnit) && volumeUnits.contains(servingUnit)) ){
            throw CountError.VolumeMassConversion
        }
        
        let ratio = unitConversionDictionary[UnitKey(from:portion.ServingUnit, to:servingUnit)]
        return ratio! * portion.Serving;
    }
}
