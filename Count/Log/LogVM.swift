//
//  LogVM.swift
//  Count
//
//  Created by Michael Phelan on 8/8/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import CoreData

class LogVM<F:EntryFetcher>: ObservableObject {
    @Published var criteria : F.criteriaType{
        didSet{
            self.fetch()
       }
    }
    @Published var logEntries: [LogEntry] = []
    @Published var selectedEntries: [LogEntry] = []
    
    private let context: NSManagedObjectContext
    private var settingsVM : SettingsVM
    private let fetcher : F

    init(context: NSManagedObjectContext, settings: SettingsVM, fetcher: F){
        self.context = context
        self.settingsVM = settings
        self._criteria = Published(initialValue: fetcher.startingCriteria)
        self.fetcher = fetcher
        self.fetch()
    }
    
    public func fetch(){
        logEntries = self.fetcher.fetchEntries(context: context, curr: self.criteria)
    }
    
    public func critAsString()->String{
        return self.fetcher.criteriaToString(crit: self.criteria)
    }
    
    public func previous(){
        self.criteria = self.fetcher.previous(curr: self.criteria)
    }
    
    public func next(){
        self.criteria = self.fetcher.next(curr: self.criteria)
    }
    
    public func deleteEntry(index: Int ){
        let deleteItem = self.logEntries[index]
        self.context.delete(deleteItem)
        
        do{
            try self.context.save()
        }catch{
            print(error)
        }
        
        self.fetch()
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
            self.fetch()
            return true
        }
        return false;
    }
    
    private func copySelected() throws {
        for entry in self.selectedEntries {
            _ = HelperFunctions.copyEntry(context: self.context, entry: entry)
        }
        try self.context.save()
    }
    
    public func performCopySelected() -> Bool {
        return bulkOperation(copySelected)
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
