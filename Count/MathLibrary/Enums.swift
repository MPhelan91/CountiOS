//
//  Enums.swift
//  Count
//
//  Created by Michael Phelan on 7/26/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation

enum Macros { case Calories, Protien, Fat, Sugar }

enum Units : Int, CaseIterable {
    
    case Gram, Ounce, Pound, Liter, Milliliter, Cup
    
    var abbreviation: String {
        switch self {
        case .Gram: return "g"
        case .Ounce   : return "oz"
        case .Pound  : return "lb"
        case .Liter : return "L"
        case .Milliliter : return "mL"
        case .Cup : return "c"
        }
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
    case NumberOfServings, Portion, Calorie, Protien
}

enum CountError: Error {
    case VolumeMassConversion, ConvertPortionWithNoPortionInfo
}
