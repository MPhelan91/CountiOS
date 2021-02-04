//
//  StartupTasks.swift
//  Count
//
//  Created by Michael Phelan on 11/9/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation
import CoreData

class StartupTask{
    static func ensureSettingsExist(_ context:NSManagedObjectContext){
        do{
            let response = try context.fetch(Settings.fetchRequest())
            if(response.count > 1){
                print("Error: More than one Setting Row Found")
            }
            
            if(response.count == 0){
                _ = Settings.getDefaultSettings(context: context)
                try context.save()
            }
            
        }catch{
            print(error)
        }
    }
    
    static func logScheduledEntries(_ context:NSManagedObjectContext){
        do{
            let response = try context.fetch(Settings.fetchRequest())
            let settings = response.first as! Settings
            
            let calendar = Calendar.current
            let lastOpened = settings.lastOpened
            if(lastOpened == nil || !calendar.isDateInToday(lastOpened!)){
                let newLastOpened = Date()
                let everyDay = try context.fetch(LogEntry.getLogEntriesScheduledFor(day:.Everyday))
                let today = try context.fetch(LogEntry.getLogEntriesScheduledFor(day: Day.getDayFromDate(newLastOpened)))
                
                everyDay.forEach{entry in _ = HelperFunctions.copyEntry(Date.self, context, entry, Date())}
                today.forEach{entry in _ = HelperFunctions.copyEntry(Date.self, context, entry, Date())}
                settings.lastOpened = newLastOpened
                
                try context.save()
            }
            
        }catch{
            print(error)
        }
    
    }
    
    static func cleanOldEntries(_ context:NSManagedObjectContext){
        do{
            let response = try context.fetch(Settings.fetchRequest())
            let settings = response.first as! Settings
            let threeWeeksAgo = Calendar.current.date(byAdding: .day, value: -21, to: Date())!
            
            if(settings.lastCleaning == nil || settings.lastCleaning! < threeWeeksAgo){
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LogEntry")
                let predicate = NSPredicate(format: "entryDate < %@", threeWeeksAgo as NSDate)
                fetchRequest.predicate = predicate
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                let result = try context.execute(deleteRequest) as! NSBatchDeleteResult
                let changes: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: result.result as! [NSManagedObjectID]
                ]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                
                settings.lastCleaning = Date()
                try context.save()
            }
        }catch{
            print(error)
        }
    }
}
