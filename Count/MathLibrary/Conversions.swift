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
    
    public static func NewConvert(definition: NutritionalInfo, fieldChanged: ChangedData, newValue: Double, newUnit: Units) throws -> NutritionalInfo{
        var result = definition
        
        result.ServingSize = result.ServingUnit != newUnit
            ? try ConvertPortion(portion: result.ServingSize, fromUnit: result.ServingUnit, toUnit: newUnit)
            : result.ServingSize
        
        let oldValue = getFieldBasedOnEnum(definition: result, fieldChanged: fieldChanged)
        
        let ratio = newValue / oldValue;
        
        result.Servings *= ratio
        result.ServingSize *= ratio
        result.ServingUnit = newUnit
        result.Calories *= ratio
        result.Protien *= ratio
        
        return result
    }
    
    public static func ConvertPortion(portion: Double, fromUnit: Units, toUnit: Units) throws -> Double {
        if((volumeUnits.contains(fromUnit) && massAndWeightUnits.contains(toUnit)) ||
            (massAndWeightUnits.contains(fromUnit) && volumeUnits.contains(toUnit)) ){
            throw CountError.VolumeMassConversion
        }
        
        let ratio = unitConversionDictionary[UnitKey(from:fromUnit, to:toUnit)]
        return ratio! * portion;
    }
    
    private static func getFieldBasedOnEnum(definition:NutritionalInfo, fieldChanged:ChangedData) -> Double {
        switch fieldChanged {
        case ChangedData.Serving:
            return definition.Servings
        case ChangedData.Portion:
            return definition.ServingSize
        case ChangedData.Calorie:
            return definition.Calories
        case ChangedData.Protien:
            return definition.Protien
        }
    }
    
    public static func Convert(servingSize:ServingInfo, servingNutrition: NutritionalInfo, portion:ServingInfo) throws -> NutritionalInfo {
        let ratio = servingSize.ServingUnit == portion.ServingUnit
            ? portion.Serving / servingSize.Serving
            : try ConvertPortion(portion: portion.Serving, fromUnit: portion.ServingUnit, toUnit: servingSize.ServingUnit) / servingSize.Serving
        
        var result = NutritionalInfo()
        result.Calories = ratio * servingNutrition.Calories
        result.Protien = ratio * servingNutrition.Protien
        return result;
    }
}
