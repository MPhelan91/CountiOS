//
//  HelperFunctions.swift
//  Count
//
//  Created by Michael Phelan on 10/20/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation
import CoreData

class HelperFunctions{
    static func sumMacros(_ macroType:Macros, _ entries: [LogEntry]) -> Double {
        switch macroType {
        case Macros.Calories:
            return entries.map({$0.calories as! Double}).reduce(0.0, +)
        case Macros.Protien:
            return entries.map({$0.protien as! Double}).reduce(0.0, +)
        case Macros.Fat:
            return entries.map({$0.fat as! Double}).reduce(0.0, +)
        case Macros.Carbs:
            return entries.map({$0.carbs as! Double}).reduce(0.0, +)
        case Macros.Sugar:
            return entries.map({$0.sugar as! Double}).reduce(0.0, +)
        }
    }
    
    static func copyEntry<T>(_ type: T.Type, _ context: NSManagedObjectContext, _ entry: LogEntry, _ timeAttribute: T) -> LogEntry{
        let newEntry = LogEntry(context: context)
        
        newEntry.name = entry.name
        newEntry.calories = entry.calories
        newEntry.protien = entry.protien
        newEntry.fat = entry.fat
        newEntry.carbs = entry.carbs
        newEntry.sugar = entry.sugar
        
        if(timeAttribute is Date){
            newEntry.entryDate = timeAttribute as! Date
        } else if(timeAttribute is Day){
            let enumValue = timeAttribute as! Day
            newEntry.scheduledFor = NSNumber(value: enumValue.rawValue)
        }
        
        return newEntry
    }
    
    static func calcEntryDate(_ date:Date) -> Date{
        let calendar = Calendar.current
        let now = Date()
        if(calendar.isDateInToday(date)){
            return now
        }
        else if(date < now){
            return date.atEndOfDay!
        }
        else{
            return date.onlyDate!
        }
    }
}
