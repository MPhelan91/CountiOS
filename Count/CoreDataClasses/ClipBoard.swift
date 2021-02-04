//
//  ClipBoard+CoreDataProperties.swift
//  Count
//
//  Created by Michael Phelan on 2/2/21.
//  Copyright © 2021 MichaelPhelan. All rights reserved.
//
//

import Foundation
import CoreData


public class ClipBoard: NSManagedObject {
    @NSManaged public var entries: NSSet?

    public var entriesAsArray: [LogEntry]{
        let set = entries as? Set<LogEntry> ?? []
        return Array(set)
    }
}

// MARK: Generated accessors for entries
extension ClipBoard {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: LogEntry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: LogEntry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}
