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
    
    static func copyEntry(context: NSManagedObjectContext, entry: LogEntry, date: Date = Date()) -> LogEntry{
        let newEntry = LogEntry(context: context)
        
        newEntry.name = entry.name
        newEntry.calories = entry.calories
        newEntry.protien = entry.protien
        newEntry.fat = entry.fat
        newEntry.carbs = entry.carbs
        newEntry.sugar = entry.sugar
        newEntry.entryDate = date
        
        return newEntry
    }
}
