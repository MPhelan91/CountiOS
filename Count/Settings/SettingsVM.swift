//
//  SettingsVM.swift
//  Count
//
//  Created by Michael Phelan on 10/9/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import CoreData

class SettingsVM : ObservableObject{
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    public func deleteOldEntries() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LogEntry")
        let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
        let predicate = NSPredicate(format: "entryDate < %@", twoWeeksAgo as NSDate)
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        do{
            let result = try context.execute(deleteRequest) as! NSBatchDeleteResult
            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: result.result as! [NSManagedObjectID]
            ]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        }catch{
            print(error)
        }
    }
}
