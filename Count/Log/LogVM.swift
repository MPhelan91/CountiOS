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
    
    private func bulkOperation(_ operation:() throws->Void) -> Bool {
        do{
            try operation()
        }catch{
            print(error)
            return false
        }
        deselectAllEntries()
        self.fetch()
        return true
    }
    
    public func deselectAllEntries(){
        selectedEntries.removeAll()
    }
    
    private func addEntries(_ entries:[LogEntry], _ timeAttribute: F.criteriaType) throws {
        for entry in entries {
            _ = HelperFunctions.copyEntry(F.criteriaType.self, self.context, entry, timeAttribute)
        }
        try self.context.save()
    }
    
    public func performAddEntries(_ entries:[LogEntry]) -> Bool{
        return bulkOperation({()throws ->Void in try addEntries(entries, self.criteria)})
    }
    
    public func performCopySelectedToToday() -> Bool {
        //TODO: This isn't great. Maybe make base Log class and then inherit for LogDate and define this class there
        if(criteria is Date){
            return bulkOperation({()throws ->Void in try addEntries(self.selectedEntries, Date() as! F.criteriaType)})
        } else{
            return false;
        }
    }
    
    private func deleteEntries(entries:[LogEntry]) throws {
        let ids = entries.map({x in x.objectID})
        let deleteRequest = NSBatchDeleteRequest(objectIDs: ids)
        deleteRequest.resultType = .resultTypeObjectIDs

        let result = try context.execute(deleteRequest) as! NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [
            NSDeletedObjectsKey: result.result as! [NSManagedObjectID]
        ]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
    }
    
    public func performDeleteEntries() -> Bool {
        return bulkOperation({()throws ->Void in try deleteEntries(entries: self.selectedEntries)})
    }
}
