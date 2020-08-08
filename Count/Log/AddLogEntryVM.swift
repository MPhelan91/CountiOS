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
    @Published var servingSize=""{
        didSet{
            recalcNutrition()
        }
    }
    @Published var servingUnit=ServingUnit.Gram{
        didSet{
            recalcNutrition()
        }
    }
    @Published var calories=""
    @Published var protien=""
    
    private let context: NSManagedObjectContext
    private var selectedEntry: DictionaryEntry?
    
    init(context: NSManagedObjectContext){
        self.context = context
        let y = try? context.fetch(DictionaryEntry.getAllDictionaryEntries())
        self.dictionaryEntries = y ?? []
        self.selectedEntry = nil
    }
    
    func setFieldsFromEntry(){
        if(!(dictionaryEntryName?.isEmpty ?? true)){
            self.selectedEntry = self.dictionaryEntries.first(where: { $0.name == dictionaryEntryName })
            self.name = selectedEntry!.name!
            self.definition = selectedEntry!.definition!
            self.servings = "1"
            self.servingSize = selectedEntry!.servingSize!.description
            self.servingUnit = ServingUnit(rawValue: selectedEntry!.servingUnit as! Int) ?? ServingUnit.Gram
            self.calories = selectedEntry!.calories!.description
            self.protien = selectedEntry!.protien!.description
        }
    }
    
    func recalcNutrition(){
        if(selectedEntry != nil){
            let servingSize = ServingInfo(serving: selectedEntry?.servingSize as! Double, unit: ServingUnit(rawValue: selectedEntry!.servingUnit as! Int) ?? ServingUnit.Gram)
            let nutritionInfo = NutritionalInfo(calories: selectedEntry?.calories as! Double, protien: selectedEntry?.protien as! Double)
            let portion = ServingInfo(serving: Double(self.servingSize) ?? 0, unit: self.servingUnit)
            
            do{
                let result = try Conversions.Convert(servingSize: servingSize, servingNutrition: nutritionInfo, portion: portion)
                
                self.calories = result.Calories.description
                self.protien = result.Protien.description
            }
            catch{
                print(error)
            }
        }
    }
    
    func addEntry(){
        let newEntry = LogEntry(context: self.context)
        
        newEntry.name = self.name
        newEntry.calories = NSDecimalNumber(value: Double(self.calories) ?? 0)
        newEntry.protien = NSDecimalNumber(value: Double(self.protien) ?? 0)
        newEntry.entryDate = Date()
        
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
        self.servingUnit = ServingUnit.Gram
        self.calories = ""
        self.protien = ""
    }
}
