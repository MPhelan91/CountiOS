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
    @Published var servingUnit=Units.Gram{
        didSet{
            RecalcNutrition(ChangedData.Portion)
        }
    }
    @Published var calories:Double? = nil
    @Published var protien:Double? = nil
    
    private let context: NSManagedObjectContext
    private var loading = false
    
    init(context: NSManagedObjectContext){
        self.context = context
        self.selectedEntry = nil
    }
    
    func setFieldsFromEntry(){
        if(selectedEntry != nil){
            self.loading = true
            self.name = selectedEntry!.name!
            self.definition = selectedEntry!.definition!
            self.servings = 1.0
            self.servingSize = selectedEntry!.servingSize as! Double?
            self.servingUnit = Units(rawValue: selectedEntry!.servingUnit as! Int) ?? Units.Gram
            self.calories = selectedEntry!.calories as! Double?
            self.protien = selectedEntry!.protien as! Double?
            self.loading = false
        }
    }
    
    public func RecalcNutrition(_ dataChanged:ChangedData){
        if(selectedEntry != nil && self.loading == false){
            let definition = NutritionalInfo(1, selectedEntry?.servingSize as! Double, Units(rawValue: selectedEntry!.servingUnit as! Int) ?? Units.Gram, selectedEntry?.calories as! Double, selectedEntry?.protien as! Double)
            
            do{
                let result = try Conversions.Convert(definition: definition, fieldChanged: dataChanged, newValue: enumToValue(dataChanged), newUnit: self.servingUnit)
                
                self.loading = true
                self.servingSize = result.PortionSize
                self.calories = result.Calories
                self.protien = result.Protien
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
        }
    }
    
    func addEntry(date:Date = Date()){
        let newEntry = LogEntry(context: self.context)
        
        newEntry.name = self.name
        newEntry.calories = NSDecimalNumber(value: self.calories ?? 0)
        newEntry.protien = NSDecimalNumber(value: self.protien ?? 0)
        newEntry.entryDate = date
        
        do{
            try self.context.save()
        }catch{
            print(error)
        }
        clearData()
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
    }
}
