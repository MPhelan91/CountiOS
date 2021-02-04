//
//  LogEntry.swift
//  Count
//
//  Created by Michael Phelan on 6/25/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation
import CoreData

public class LogEntry:NSManagedObject,Identifiable{
    @NSManaged public var entryDate:Date?
    @NSManaged public var name:String?
    @NSManaged public var calories:NSDecimalNumber?
    @NSManaged public var protien:NSDecimalNumber?
    @NSManaged public var carbs:NSDecimalNumber?
    @NSManaged public var fat:NSDecimalNumber?
    @NSManaged public var sugar:NSDecimalNumber?
    @NSManaged public var scheduledFor:NSNumber?
    @NSManaged public var clipBoard:ClipBoard?
}

extension LogEntry{
    static func getLogEntriesForDate(date:Date) -> NSFetchRequest<LogEntry> {
        let request: NSFetchRequest<LogEntry> = LogEntry.fetchRequest() as! NSFetchRequest<LogEntry>

        let sortDescriptor = NSSortDescriptor(key: "entryDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let startDate = date.onlyDate
        let endDate = startDate!.addingTimeInterval(24*60*60).addingTimeInterval(-1)
        
        request.predicate = NSPredicate(format: "(entryDate != nil) AND (entryDate >= %@) AND (entryDate <= %@)", startDate! as NSDate, endDate as NSDate)
        
        return request
    }
    
    static func getLogEntriesScheduledFor(day:Day) -> NSFetchRequest<LogEntry> {
        let request: NSFetchRequest<LogEntry> = LogEntry.fetchRequest() as! NSFetchRequest<LogEntry>
                
        request.predicate = NSPredicate(format: "(scheduledFor != nil) AND (scheduledFor == %d)", day.rawValue)
        
        return request
    }
}
