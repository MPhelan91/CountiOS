//
//  DictionaryEntry.swift
//  Count
//
//  Created by Michael Phelan on 7/23/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation
import CoreData

public class DictionaryEntry:NSManagedObject,Identifiable{
    @NSManaged public var name:String?
    @NSManaged public var definition:String?
    @NSManaged public var calories:NSNumber?
    @NSManaged public var protien:NSNumber?
    @NSManaged public var fat:NSNumber?
    @NSManaged public var carbs:NSNumber?
    @NSManaged public var sugar:NSNumber?
    @NSManaged public var servingUnit:NSNumber?
    @NSManaged public var servingSize:NSDecimalNumber?
}

extension DictionaryEntry{
    static func getAllDictionaryEntries() -> NSFetchRequest<DictionaryEntry> {
        let request: NSFetchRequest<DictionaryEntry> = DictionaryEntry.fetchRequest() as! NSFetchRequest<DictionaryEntry>
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
