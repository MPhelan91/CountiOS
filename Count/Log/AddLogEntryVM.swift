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
    @Published var dictionaryEntries: [DictionaryEntry] = []
    @Published var dictionaryEntryName : String? {
        didSet{
            setFieldsFromEntry()
        }
    }
    @Published var name = ""
    @Published var definition = ""
    @Published var servings=""
    @Published var servingSize=""
    @Published var servingUnit=Units.Gram{
        didSet{
            RecalcNutrition(ChangedData.Portion)
        }
    }
    @Published var calories=""
    @Published var protien=""
    
    private let context: NSManagedObjectContext
    private var selectedEntry: DictionaryEntry?
    private var loading = false
    
    init(context: NSManagedObjectContext){
        self.context = context
        let y = try? context.fetch(DictionaryEntry.getAllDictionaryEntries())
        self.dictionaryEntries = y ?? []
        self.selectedEntry = nil
    }
    
    func setFieldsFromEntry(){
        if(!(dictionaryEntryName?.isEmpty ?? true)){
            self.loading = true
            self.selectedEntry = self.dictionaryEntries.first(where: { $0.name == dictionaryEntryName })
            self.name = selectedEntry!.name!
            self.definition = selectedEntry!.definition!
            self.servings = "1"
            self.servingSize = selectedEntry!.servingSize!.description
            self.servingUnit = Units(rawValue: selectedEntry!.servingUnit as! Int) ?? Units.Gram
            self.calories = selectedEntry!.calories!.description
            self.protien = selectedEntry!.protien!.description
            self.loading = false
        }
    }
    
    public func RecalcNutrition(_ dataChanged:ChangedData){
        if(selectedEntry != nil && self.loading == false){
            let definition = NutritionalInfo(1, selectedEntry?.servingSize as! Double, Units(rawValue: selectedEntry!.servingUnit as! Int) ?? Units.Gram, selectedEntry?.calories as! Double, selectedEntry?.protien as! Double)
            
            do{
                let result = try Conversions.Convert(definition: definition, fieldChanged: dataChanged, newValue: enumToValue(dataChanged), newUnit: self.servingUnit)
                
                self.loading = true
                self.servingSize = result.PortionSize.description
                self.calories = result.Calories.description
                self.protien = result.Protien.description
                self.servings = result.NumberOfServings.description
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
            return Double(self.servings) ?? 0
        case ChangedData.Portion:
            return Double(self.servingSize) ?? 0
        case ChangedData.Calorie:
            return Double(self.calories) ?? 0
        case ChangedData.Protien:
            return Double(self.protien) ?? 0
        }
    }
    
    func addEntry(date:Date = Date()){
        let newEntry = LogEntry(context: self.context)
        
        newEntry.name = self.name
        newEntry.calories = NSDecimalNumber(value: Double(self.calories) ?? 0)
        newEntry.protien = NSDecimalNumber(value: Double(self.protien) ?? 0)
        newEntry.entryDate = date
        
        do{
            try self.context.save()
        }catch{
            print(error)
        }
        clearData()
    }
    
    func clearData(){
        self.dictionaryEntryName = nil
        self.selectedEntry = nil
        self.name = ""
        self.definition = ""
        self.servings = ""
        self.servingSize = ""
        self.servingUnit = Units.Gram
        self.calories = ""
        self.protien = ""
    }
}
