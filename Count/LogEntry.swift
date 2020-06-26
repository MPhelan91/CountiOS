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
    @NSManaged public var calories:Decimal
    @NSManaged public var protien:Decimal
}

extension LogEntry{
    static func getAllLogEntries() -> NSFetchRequest<LogEntry> {
        let request: NSFetchRequest<LogEntry> = LogEntry.fetchRequest() as! NSFetchRequest<LogEntry>
        
        let sortDescriptor = NSSortDescriptor(key: "entryDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
