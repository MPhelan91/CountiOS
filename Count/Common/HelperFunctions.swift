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
            return entries.map({$0.calories?.doubleValue ?? 0}).reduce(0.0, +)
        case Macros.Protien:
            return entries.map({$0.protien?.doubleValue ?? 0}).reduce(0.0, +)
        case Macros.Fat:
            return entries.map({$0.fat?.doubleValue ?? 0}).reduce(0.0, +)
        case Macros.Carbs:
            return entries.map({$0.carbs?.doubleValue ?? 0}).reduce(0.0, +)
        case Macros.Sugar:
            return entries.map({$0.sugar?.doubleValue ?? 0}).reduce(0.0, +)
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
    
    static func calcTopOff(_ goals: [MacroGoal], _ entries:[LogEntry],_ macro:Macros ) -> Double{
        let sum = sumMacros(macro, entries)
        let goal = Double(goals.first(where: { $0.macro == macro })!.goal!)
        return goal > 0 && sum < goal ? goal - sum : 0.0
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
