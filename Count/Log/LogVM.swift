//
//  LogVM.swift
//  Count
//
//  Created by Michael Phelan on 8/8/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import CoreData

class LogVM: ObservableObject {
    @Published var dateForCurrentEntries = Date(){
        didSet{
            fetchEntries()
        }
    }
    @Published var logEntries: [LogEntry] = []
    @Published var selectedEntries: [LogEntry] = []
    
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
    
    public func selelctEntry(objectId:NSManagedObjectID){
        let entry = self.logEntries.first(where: { $0.objectID.isEqual(objectId) })
        selectedEntries.append(entry!)
    }
    
    public func unselectEntry(objectId:NSManagedObjectID){
        selectedEntries.removeAll(where: {$0.objectID.isEqual(objectId)})
    }
    
    public func isSelected(objectId:NSManagedObjectID) -> Bool {
        return selectedEntries.contains(where: {$0.objectID.isEqual(objectId)})
    }
    
    public func copySelected() -> Bool {
        if(self.selectedEntries.count > 0){
            for entry in self.selectedEntries {
                let newEntry = LogEntry(context: self.context)
                
                newEntry.name = entry.name
                newEntry.calories = entry.calories
                newEntry.protien = entry.protien
                newEntry.entryDate = Date()
                
                do{
                    try self.context.save()
                }catch{
                    print(error)
                    return false
                }
            }
            selectedEntries.removeAll()
            fetchEntries()
            return true
        }
        return false
    }
}
