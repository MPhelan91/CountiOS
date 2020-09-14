//
//  Extensions.swift
//  Count
//
//  Created by Michael Phelan on 8/8/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation

extension Date {

    var onlyDate: Date? {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)
        }
    }

}

extension String {
    static var formatter = NumberFormatter()
    func roundDecimalString(_ decimalPrecision:Int) -> String?{
        let numericValue = Double(self)
        if(numericValue == nil){return nil}
        
        String.formatter.minimumFractionDigits = 0
        String.formatter.maximumFractionDigits = decimalPrecision
        String.formatter.roundingMode = .halfUp
        String.formatter.minimumIntegerDigits = 1
        
        return String.formatter.string(from: NSNumber(value: numericValue!))
    }
    
    func getSubstringAfter(_ subString: String) -> String?{
        if let range = self.range(of: subString) {
            return String(self[range.upperBound...])
        }
        
        return nil
    }
    
    func getFirstDecimalValue() -> Double?{
        var decimalAsString = ""
        
        for character in self{
            if(Double(decimalAsString + String(character)) != nil){
                decimalAsString.append(character)
            }
            else if(!decimalAsString.isEmpty){
                break
            }
        }
        
        return Double(decimalAsString)
    }

    func getFirstIntegerValue() -> Int?{
        var decimalAsString = ""
        
        for character in self{
            if(Int(decimalAsString + String(character)) != nil){
                decimalAsString.append(character)
            }
            else if(!decimalAsString.isEmpty){
                break
            }
        }
        
        return Int(decimalAsString)
    }
    
    func getServingSizeInfo() -> (Int,Units)?{
        var subString = self.getSubstringAfter("serving size") ?? ""
        subString = subString.getSubstringAfter("(") ?? ""
        
        let portion = subString.getFirstIntegerValue() ?? 0
        subString = subString.getSubstringAfter(portion.description) ?? ""
        
        let unitString = subString.components(separatedBy: ")")[0]
        let unit = Units.AbbreviationToEnum(unitString)
        
        return (portion > 0 && unit != nil)
                ? (portion, unit!)
                : nil
    }
    
}

extension Double {
    static var formatter = NumberFormatter()
    func roundDecimalString(_ decimalPrecision: Int) -> String?{
        String.formatter.minimumFractionDigits = 0
        String.formatter.maximumFractionDigits = decimalPrecision
        String.formatter.roundingMode = .halfUp
        String.formatter.minimumIntegerDigits = 1
        
        return String.formatter.string(from: NSNumber(value: self))
    }
}
