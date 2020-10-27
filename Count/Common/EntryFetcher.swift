//
//  LogEntryFetcher.swift
//  Count
//
//  Created by Michael Phelan on 10/23/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import CoreData

protocol EntryFetcher {
    associatedtype criteriaType
    var startingCriteria : criteriaType {get}
    func previous(curr:criteriaType) -> criteriaType
    func next(curr:criteriaType) -> criteriaType
    func criteriaToString(crit:criteriaType) -> String
    func fetchEntries(context:NSManagedObjectContext, curr: criteriaType) -> [LogEntry]
}
