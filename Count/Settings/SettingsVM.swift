//
//  SettingsVM.swift
//  Count
//
//  Created by Michael Phelan on 10/9/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import CoreData

class SettingsVM : ObservableObject{
    @Published var massUnit:Units = .Undefined{
        didSet{
            self.settings?.massUnit = massUnit != .Undefined ? NSNumber(value:massUnit.rawValue) : nil
            saveSettings()
        }
    }
    @Published var volumeUnit:Units = .Undefined{
        didSet{
            self.settings?.volumeUnit = volumeUnit != .Undefined ? NSNumber(value:volumeUnit.rawValue) : nil
            saveSettings()
        }
    }
    @Published var macros:[Macros] = []{
        didSet{
            if(!loadingMacros){
                self.settings?.countCalories = macros.contains(Macros.Calories) ? 1 : 0
                self.settings?.countProtien = macros.contains(Macros.Protien) ? 1 : 0
                self.settings?.countFat = macros.contains(Macros.Fat) ? 1 : 0
                self.settings?.countSugar = macros.contains(Macros.Sugar) ? 1 : 0
                self.settings?.countCarbs = macros.contains(Macros.Carbs) ? 1 : 0
                saveSettings()
            }
        }
    }

    private var settings : Settings? = nil
    private let context: NSManagedObjectContext
    private var loadingMacros = false
    
    init(context: NSManagedObjectContext){
        self.context = context
        fetchSettings()
    }
    
    private func saveSettings(){
        do{
            try self.context.save()
        } catch{
            print(error)
        }
    }
    
    private func fetchSettings(){
        do{
            let settings = try context.fetch(Settings.getSettings())
            self.settings = settings.count == 0
                ? Settings.getDefaultSettings(context: self.context)
                : settings.first
            
            massUnit = self.settings!.massUnit != nil ? Units(rawValue: self.settings!.massUnit as! Int)! : .Undefined
            volumeUnit = self.settings!.volumeUnit != nil ? Units(rawValue: self.settings!.volumeUnit as! Int)! : .Undefined
            
            self.loadingMacros = true
            if(self.settings!.countCalories == 1){macros.append(Macros.Calories)}
            if(self.settings!.countProtien == 1){macros.append(Macros.Protien)}
            if(self.settings!.countSugar == 1){macros.append(Macros.Sugar)}
            if(self.settings!.countFat == 1){macros.append(Macros.Fat)}
            if(self.settings!.countCarbs == 1){macros.append(Macros.Carbs)}
            self.loadingMacros = false
        } catch {
            print(error)
        }
    }
    
    public func deleteSettings(){
        if(self.settings != nil){
            context.delete(self.settings!)
            saveSettings()
        }
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
