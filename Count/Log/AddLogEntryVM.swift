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
    @Published var servingUnit=Units.Gram{
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
            self.servingUnit = Units(rawValue: selectedEntry!.servingUnit as! Int) ?? Units.Gram
            self.calories = selectedEntry!.calories!.description
            self.protien = selectedEntry!.protien!.description
        }
    }
    
    func recalcNutrition(){
        if(selectedEntry != nil){
            let servingSize = ServingInfo(Serving: selectedEntry?.servingSize as! Double, ServingUnit: Units(rawValue: selectedEntry!.servingUnit as! Int) ?? Units.Gram)
            let nutritionInfo = NutritionalInfo(Calories: selectedEntry?.calories as! Double, Protien: selectedEntry?.protien as! Double)
            let portion = ServingInfo(Serving: Double(self.servingSize) ?? 0, ServingUnit: self.servingUnit)
            
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
