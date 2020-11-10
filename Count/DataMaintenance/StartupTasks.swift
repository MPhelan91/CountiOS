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
                
                everyDay.forEach{entry in _ = HelperFunctions.copyEntry(context: context, entry: entry)}
                today.forEach{entry in _ = HelperFunctions.copyEntry(context: context, entry: entry)}
                settings.lastOpened = newLastOpened
                
                try context.save()
            }
            
        }catch{
            print(error)
        }
    
    }
}
