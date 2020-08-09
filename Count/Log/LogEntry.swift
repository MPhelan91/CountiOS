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
}

extension LogEntry{
    static func getAllLogEntries() -> NSFetchRequest<LogEntry> {
        let request: NSFetchRequest<LogEntry> = LogEntry.fetchRequest() as! NSFetchRequest<LogEntry>
        
        let sortDescriptor = NSSortDescriptor(key: "entryDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
    static func getLogEntriesForDate(date:Date) -> NSFetchRequest<LogEntry> {
        let request: NSFetchRequest<LogEntry> = LogEntry.fetchRequest() as! NSFetchRequest<LogEntry>
        
        let sortDescriptor = NSSortDescriptor(key: "entryDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let startDate = date.onlyDate as! Date
        let endDate = startDate.addingTimeInterval(24*60*60)
        
        request.predicate = NSPredicate(format: "(entryDate >= %@) AND (entryDate <= %@)", startDate as NSDate, endDate as NSDate)
        
        return request
    }
}
