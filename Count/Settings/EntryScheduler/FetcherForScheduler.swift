//
//  FetcherForScheduler.swift
//  Count
//
//  Created by Michael Phelan on 10/27/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import CoreData

class FetcherForScheduler: EntryFetcher {
    typealias criteriaType = Day
    
    public let startingCriteria : criteriaType = Day.Everyday
    private let days: [Day] = Day.allCases
    
    func previous(curr:criteriaType) -> criteriaType {
        let previousIndex = days.firstIndex(of: curr)! - 1
        return previousIndex < 0 ? Day.Saturday : days[previousIndex];
    }
    
    func next(curr:criteriaType) -> criteriaType {
        let nextIndex = days.firstIndex(of: curr)! + 1
        return nextIndex >= days.count ? Day.Everyday : days[nextIndex];
    }
    
    func criteriaToString(crit:criteriaType) -> String{
        return crit.asString
    }
    
    func fetchEntries(context: NSManagedObjectContext, curr:criteriaType) -> [LogEntry] {
        let entries = try? context.fetch(LogEntry.getLogEntriesScheduledFor(day:curr))
        return entries ?? []
    }
}
