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
