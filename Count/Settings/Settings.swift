//
//  Settings+CoreDataClass.swift
//  Count
//
//  Created by Michael Phelan on 10/9/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//
//

import Foundation
import CoreData

public class Settings: NSManagedObject {
    @NSManaged public var massUnit: NSNumber?
    @NSManaged public var volumeUnit: NSNumber?
    @NSManaged public var calorieGoal: NSNumber?
    @NSManaged public var protienGoal: NSNumber?
    @NSManaged public var carbGoal: NSNumber?
    @NSManaged public var fatGoal: NSNumber?
    @NSManaged public var sugarGoal: NSNumber?
    @NSManaged public var lastCleaning: Date?
    @NSManaged public var lastOpened: Date?
}

import Foundation
import CoreData


extension Settings {
    static func getDefaultSettings(context:NSManagedObjectContext) -> Settings{
        let defaultSettings = Settings(context: context)
        defaultSettings.massUnit = nil
        defaultSettings.volumeUnit = nil
        defaultSettings.calorieGoal = 2600
        defaultSettings.protienGoal = 190
        defaultSettings.carbGoal = 0
        defaultSettings.fatGoal = 0
        defaultSettings.sugarGoal = 0
        defaultSettings.lastOpened = nil
        defaultSettings.lastCleaning = nil
        return defaultSettings
    }
    
    static func getSettings() -> NSFetchRequest<Settings> {
        let request = Settings.fetchRequest() as! NSFetchRequest<Settings>
        request.fetchLimit = 1
        return request
    }
}
