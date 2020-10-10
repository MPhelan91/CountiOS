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
}

import Foundation
import CoreData


extension Settings {
    static func getDefaultSettings(context:NSManagedObjectContext) -> Settings{
        let defaultSettings = Settings(context: context)
        defaultSettings.massUnit = nil
        defaultSettings.volumeUnit = nil
        return defaultSettings
    }
    
    static func getSettings() -> NSFetchRequest<Settings> {
        let request = Settings.fetchRequest() as! NSFetchRequest<Settings>
        request.fetchLimit = 1
        return request
    }
}
