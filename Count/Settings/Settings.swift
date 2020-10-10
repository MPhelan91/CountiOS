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
    @NSManaged public var countCalories: NSNumber?
    @NSManaged public var countProtien: NSNumber?
    @NSManaged public var countCarbs: NSNumber?
    @NSManaged public var countFat: NSNumber?
    @NSManaged public var countSugar: NSNumber?
}

import Foundation
import CoreData


extension Settings {
    static func getDefaultSettings(context:NSManagedObjectContext) -> Settings{
        let defaultSettings = Settings(context: context)
        defaultSettings.massUnit = nil
        defaultSettings.volumeUnit = nil
        defaultSettings.countCalories = 1
        defaultSettings.countProtien = 1
        defaultSettings.countCarbs = 0
        defaultSettings.countFat = 0
        defaultSettings.countSugar = 0
        return defaultSettings
    }
    
    static func getSettings() -> NSFetchRequest<Settings> {
        let request = Settings.fetchRequest() as! NSFetchRequest<Settings>
        request.fetchLimit = 1
        return request
    }
}
