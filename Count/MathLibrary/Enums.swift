//
//  Enums.swift
//  Count
//
//  Created by Michael Phelan on 7/26/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation

enum Macros : Int, CaseIterable, Hashable{    
    
    case Calories, Protien, Fat, Carbs, Sugar
    
    var getFullName:String{
        switch self{
        case.Calories: return "Calories"
        case.Protien: return "Protien"
        case.Fat: return "Fat"
        case.Carbs: return "Carbs"
        case.Sugar: return "Sugar"
        }
    }
    
    var getShortName:String{
        switch self{
        case.Calories: return "Cal"
        case.Protien: return "Pro"
        case.Fat: return "Fat"
        case.Carbs: return "Carbs"
        case.Sugar: return "Sugar"
        }
    }
}

enum Units : Int, CaseIterable {
    
    case Gram, Ounce, Pound, Liter, Milliliter, Cup, Undefined
    
    var abbreviation: String {
        switch self {
        case .Gram: return "g"
        case .Ounce   : return "oz"
        case .Pound  : return "lb"
        case .Liter : return "L"
        case .Milliliter : return "mL"
        case .Cup : return "c"
        case .Undefined: return ""
        }
    }
    
    static func onlyUnits() -> [Units]{
        return [.Gram, .Ounce, .Pound, .Liter, .Milliliter, .Cup]
    }
    
    static func massUnits()->[Units]{
        return [.Undefined, .Gram, .Ounce, .Pound]
    }
    
    static func volumeUnits()->[Units]{
        return [.Undefined, .Cup, .Liter, .Milliliter]
    }
    
    static func AbbreviationToEnum(_ abbrev:String) -> Units?{
        switch abbrev {
        case "g":   return .Gram
        case "oz"   : return .Ounce
        case "lb"  : return .Pound
        case "L" : return .Liter
        case "mL" : return .Milliliter
        case "c" : return .Cup
        default: return nil
        }
    }
}

enum ChangedData : CaseIterable{
    case NumberOfServings, Portion, Calorie, Protien, Fat, Carbs, Sugar
    
    static func MacroToChangedData(_ macro: Macros) -> ChangedData{
        switch macro {
        case Macros.Calories:
            return ChangedData.Calorie
        case Macros.Protien:
            return ChangedData.Protien
        case Macros.Fat:
            return ChangedData.Fat
        case Macros.Carbs:
            return ChangedData.Carbs
        case Macros.Sugar:
            return ChangedData.Sugar
        }
    }
}

enum CountError: Error {
    case VolumeMassConversion, ConvertPortionWithNoPortionInfo
}
