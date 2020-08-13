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
    
    public static func Convert(definition: NutritionalInfo, fieldChanged: ChangedData, newValue: Double, newUnit: Units) throws -> NutritionalInfo{
        var result = definition
        
        result.PortionSize = result.PortionUnit != newUnit
            ? try ConvertPortion(portion: result.PortionSize, fromUnit: result.PortionUnit, toUnit: newUnit)
            : result.PortionSize
        
        let oldValue = getFieldBasedOnEnum(definition: result, fieldChanged: fieldChanged)
        
        let ratio = newValue / oldValue;
        
        result.NumberOfServings *= ratio
        result.PortionSize *= ratio
        result.PortionUnit = newUnit
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
        case ChangedData.NumberOfServings:
            return definition.NumberOfServings
        case ChangedData.Portion:
            return definition.PortionSize
        case ChangedData.Calorie:
            return definition.Calories
        case ChangedData.Protien:
            return definition.Protien
        }
    }
}
