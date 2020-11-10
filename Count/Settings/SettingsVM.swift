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
            self.settings.massUnit = massUnit != .Undefined ? NSNumber(value:massUnit.rawValue) : nil
            saveSettings()
        }
    }
    @Published var volumeUnit:Units = .Undefined{
        didSet{
            self.settings.volumeUnit = volumeUnit != .Undefined ? NSNumber(value:volumeUnit.rawValue) : nil
            saveSettings()
        }
    }
    @Published var macroGoals:[MacroGoal] = []{
        didSet{
            if(!loadingMacroGoals){
                updateMacroGoals()
                saveSettings()
            }
        }
    }

    public var settings : Settings
    private let context: NSManagedObjectContext
    private var loadingMacroGoals = false
    
    init(context: NSManagedObjectContext){
        self.context = context
        do{
            let settings = try context.fetch(Settings.fetchRequest())
            self.settings = settings.first as! Settings
            loadSettings()
        } catch {
            self.settings = Settings()
            print(error)
        }
    }
    
    private func saveSettings(){
        do{
            try self.context.save()
        } catch{
            print(error)
        }
    }
    
    private func loadSettings(){
        massUnit = self.settings.massUnit != nil ? Units(rawValue: self.settings.massUnit as! Int)! : .Undefined
        volumeUnit = self.settings.volumeUnit != nil ? Units(rawValue: self.settings.volumeUnit as! Int)! : .Undefined
        
        self.loadingMacroGoals = true
        self.macroGoals = createMacroGoalList()
        self.loadingMacroGoals = false

    }
    
    private func createMacroGoalList() -> [MacroGoal]{
        var goals : [MacroGoal] = []
        goals.append(MacroGoal(Macros.Calories, self.settings.calorieGoal as! Int))
        goals.append(MacroGoal(Macros.Protien, self.settings.protienGoal as! Int))
        goals.append(MacroGoal(Macros.Fat, self.settings.fatGoal as! Int))
        goals.append(MacroGoal(Macros.Carbs, self.settings.carbGoal as! Int))
        goals.append(MacroGoal(Macros.Sugar, self.settings.sugarGoal as! Int))
        return goals
    }
    
    private func updateMacroGoals(){
        self.settings.calorieGoal = NSNumber(value:getGoal(Macros.Calories))
        self.settings.carbGoal = NSNumber(value:getGoal(Macros.Carbs))
        self.settings.sugarGoal = NSNumber(value:getGoal(Macros.Sugar))
        self.settings.fatGoal = NSNumber(value:getGoal(Macros.Fat))
        self.settings.protienGoal = NSNumber(value:getGoal(Macros.Protien))
    }
    
    private func getGoal(_ macro: Macros) -> Int{
        return macroGoals.first(where: {x in x.macro == macro})!.goal ?? 0
    }
    
    public func macrosCounted() -> [Macros]{
        return self.macroGoals.filter({x in x.goal != nil && x.goal! > 0}).map({$0.macro})
    }
    
    public func deleteSettings(){
        do{
            let allSettings = try context.fetch(Settings.fetchRequest()) as! [NSManagedObject]
            allSettings.forEach({x in context.delete(x)})
            saveSettings()
        } catch{
            print(error)
        }
    }
}
