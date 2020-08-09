//
//  LogVM.swift
//  Count
//
//  Created by Michael Phelan on 8/8/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI
import CoreData

class LogVM: ObservableObject {
    @Published var dateForCurrentEntries = Date(){
        didSet{
            fetchEntries()
        }
    }
    @Published var logEntries: [LogEntry] = []
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
        fetchEntries()
    }
    
    public func decrementDay(){
        self.dateForCurrentEntries = self.dateForCurrentEntries.addingTimeInterval(-24*60*60);
    }
    
    public func incrementDay(){
        self.dateForCurrentEntries = self.dateForCurrentEntries.addingTimeInterval(24*60*60);
    }
    
    public func fetchEntries(){
        let y = try? context.fetch(LogEntry.getLogEntriesForDate(date:dateForCurrentEntries))
        self.logEntries = y ?? []
    }
    
    public func deleteEntry(index: Int ){
        let deleteItem = self.logEntries[index]
        self.context.delete(deleteItem)
        
        do{
            try self.context.save()
        }catch{
            print(error)
        }
        
        fetchEntries()
    }
}
