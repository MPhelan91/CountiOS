//
//  EntrySchedulerVM.swift
//  Count
//
//  Created by Michael Phelan on 10/23/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import CoreData

class EntrySchedulerVM: ObservableObject {
    @Published var day = Day.Everyday{
        didSet{
            fetchEntries()
        }
    }
    @Published var logEntries: [LogEntry] = []
    @Published var selectedEntries: [LogEntry] = []
    
    private let context: NSManagedObjectContext
    private let days: [Day] = Day.allCases

    init(context: NSManagedObjectContext){
        self.context = context
        fetchEntries()
    }
    
    public func previousDay(){
        let previousIndex = days.firstIndex(of: self.day)! - 1
        self.day = previousIndex < 0 ? Day.Saturday : days[previousIndex];
    }
    
    public func nextDay(){
        let nextIndex = days.firstIndex(of: self.day)! + 1
        self.day = nextIndex >= days.count ? Day.Everyday : days[nextIndex];
    }
    
    public func fetchEntries(){
        let y = try? context.fetch(LogEntry.getLogEntriesScheduledFor(day: day))
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
    
    private func bulkOperation(_ operation:() throws->Void) -> Bool{
        if(self.selectedEntries.count > 0){
            do{
                try operation()
            }catch{
                print(error)
                return false
            }
            selectedEntries.removeAll()
            fetchEntries()
            return true
        }
        return false;
    }
    
    private func deleteEntries() throws {
        let ids = selectedEntries.map({x in x.objectID})
        let deleteRequest = NSBatchDeleteRequest(objectIDs: ids)
        deleteRequest.resultType = .resultTypeObjectIDs

        let result = try context.execute(deleteRequest) as! NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [
            NSDeletedObjectsKey: result.result as! [NSManagedObjectID]
        ]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
    }
    
    public func performDeleteEntries() -> Bool {
        return bulkOperation(deleteEntries)
    }
}
