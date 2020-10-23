//
//  AddLogEntryVM.swift
//  Count
//
//  Created by Michael Phelan on 8/8/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI
import CoreData

class AddLogEntryVM: ObservableObject {
    @Published var selectedEntry : DictionaryEntry? {
        didSet{
            setFieldsFromEntry()
        }
    }
    @Published var name = ""
    @Published var definition = ""
    @Published var servings:Double? = nil
    @Published var servingSize:Double? = nil
    @Published var servingUnit:Units?=nil{
        didSet{
            RecalcNutrition(ChangedData.Portion)
        }
    }
    @Published var calories:Double? = nil
    @Published var protien:Double? = nil
    @Published var fat:Double? = nil
    @Published var carbs:Double? = nil
    @Published var sugar:Double? = nil
    
    private let context: NSManagedObjectContext
    private var settingsVM : SettingsVM
    private var loading = false
    
    init(context: NSManagedObjectContext, settings: SettingsVM){
        self.context = context
        self.selectedEntry = nil
        self.settingsVM = settings
    }
    
    func setFieldsFromEntry(){
        if(selectedEntry != nil){
            self.loading = true
            self.name = selectedEntry!.name!
            self.definition = selectedEntry!.definition!
            self.servings = 1.0
            self.servingSize = selectedEntry!.servingSize as! Double?
            self.servingUnit = selectedEntry!.servingUnit != nil ? Units(rawValue: selectedEntry!.servingUnit as! Int) : nil
            self.calories = selectedEntry!.calories as! Double?
            self.protien = selectedEntry!.protien as! Double?
            self.fat = selectedEntry!.fat as! Double?
            self.carbs = selectedEntry!.carbs as! Double?
            self.sugar = selectedEntry!.sugar as! Double?
            self.loading = false
            
            setDefaultUnit()
        }
    }
    
    private func setDefaultUnit(){
        if(self.servingUnit != nil){
            let isMassUnit = Units.massUnits().contains(self.servingUnit!)
            let defaultUnit = isMassUnit ? settingsVM.massUnit : settingsVM.volumeUnit
            if(defaultUnit != .Undefined){
                self.servingUnit = defaultUnit
            }
        }
    }
    
    public func RecalcNutrition(_ dataChanged:ChangedData){
        if(selectedEntry != nil && self.loading == false){
            let portionSize = selectedEntry?.servingSize != nil ? (selectedEntry?.servingSize as! Double) : nil
            let portionUnit = selectedEntry?.servingUnit != nil ? Units(rawValue: selectedEntry!.servingUnit as! Int) : nil
            
            let definition = NutritionalInfo(1, portionSize, portionUnit, selectedEntry?.calories as! Double, selectedEntry?.protien as! Double, selectedEntry?.carbs as! Double, selectedEntry?.fat as! Double, selectedEntry?.sugar as! Double)
            
            do{
                let result = try Conversions.Convert(definition: definition, fieldChanged: dataChanged, newValue: enumToValue(dataChanged), newUnit: self.servingUnit ?? Units.Gram)
                
                self.loading = true
                self.servingSize = result.PortionSize
                self.calories = result.Calories
                self.protien = result.Protien
                self.fat = result.Fat
                self.carbs = result.Carbs
                self.sugar = result.Sugar
                self.servings = result.NumberOfServings
                self.loading = false
            }
            catch{
                print(error)
            }
        }
    }
    
    func enumToValue(_ dataChanged:ChangedData) -> Double{
        switch dataChanged {
        case ChangedData.NumberOfServings:
            return self.servings ?? 0
        case ChangedData.Portion:
            return self.servingSize ?? 0
        case ChangedData.Calorie:
            return self.calories ?? 0
        case ChangedData.Protien:
            return self.protien ?? 0
        case ChangedData.Fat:
            return self.fat ?? 0
        case ChangedData.Carbs:
            return self.carbs ?? 0
        case ChangedData.Sugar:
            return self.sugar ?? 0
        }
    }
    
    func addScheduledEntry(day:Day){
        let newEntry = createEntry()
        newEntry.scheduledFor = NSNumber(value: day.rawValue)
        saveAndClearData()
    }
    
    func addEntry(date:Date){
        let newEntry = createEntry()
        newEntry.entryDate = date
        saveAndClearData()
    }
    
    private func saveAndClearData(){
        do{
            try self.context.save()
        }catch{
            print(error)
        }
        clearData()
    }
    
    private func createEntry() -> LogEntry{
        let newEntry = LogEntry(context: self.context)
        newEntry.name = self.name.isEmpty ? "Manual Entry" : self.name
        newEntry.calories = NSDecimalNumber(value: self.calories ?? 0)
        newEntry.protien = NSDecimalNumber(value: self.protien ?? 0)
        newEntry.fat = NSDecimalNumber(value: self.fat ?? 0)
        newEntry.carbs = NSDecimalNumber(value: self.carbs ?? 0)
        newEntry.sugar = NSDecimalNumber(value: self.sugar ?? 0)
        return newEntry
    }
    
    func clearData(){
        self.selectedEntry = nil
        self.name = ""
        self.definition = ""
        self.servings = nil
        self.servingSize = nil
        self.servingUnit = Units.Gram
        self.calories = nil
        self.protien = nil
        self.fat = nil
        self.carbs = nil
        self.sugar = nil
    }
}
