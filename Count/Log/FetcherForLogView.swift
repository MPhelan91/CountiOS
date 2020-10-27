//
//  LogViewFetcher.swift
//  Count
//
//  Created by Michael Phelan on 10/23/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import CoreData

class FetcherForLogView: EntryFetcher {
    typealias criteriaType = Date
    
    public let startingCriteria : criteriaType = Date()
    
    func previous(curr:criteriaType) -> criteriaType {
        return curr.addingTimeInterval(-24*60*60);
    }
    
    func next(curr:criteriaType) -> criteriaType {
        return curr.addingTimeInterval(24*60*60);
    }
    
    func criteriaToString(crit:criteriaType) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: crit)
    }
    
    func fetchEntries(context: NSManagedObjectContext, curr:criteriaType) -> [LogEntry] {
        let entries = try? context.fetch(LogEntry.getLogEntriesForDate(date:curr))
        return entries ?? []
    }
}
