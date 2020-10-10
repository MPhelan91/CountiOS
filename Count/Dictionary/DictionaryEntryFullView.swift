//
//  NewDictionaryEntryView.swift
//  Count
//
//  Created by Michael Phelan on 7/26/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct DictionaryEntryFullView : View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var showScanner = false;
    
    @State private var name = ""
    @State private var definition = ""
    @State private var servingSize:Int? = nil
    @State private var servingUnit : Units? = nil
    @State private var calories:Int? =  nil
    @State private var protien:Int? =  nil
    @State private var carbs:Int? =  nil
    @State private var sugar:Int? =  nil
    @State private var fat:Int? =  nil
    
    private var entryToEdit : DictionaryEntry? = nil
    
    init(_ entry: DictionaryEntry) {
        _name = State(initialValue: entry.name!)
        _definition = State(initialValue: entry.definition!)
        _servingSize = entry.servingSize == nil ? State(initialValue: nil) : State(initialValue: (entry.servingSize as! Int))
        _servingUnit = entry.servingSize == nil ? State(initialValue: nil) : State(initialValue: Units(rawValue: entry.servingUnit as! Int) ?? Units.Gram)
        _calories = entry.calories == nil ? State(initialValue: nil) : State(initialValue: (entry.calories as! Int))
        _protien = entry.protien == nil ? State(initialValue: nil) : State(initialValue: (entry.protien as! Int))
        _carbs = entry.carbs == nil ? State(initialValue: nil) : State(initialValue: (entry.carbs as! Int))
        _fat = entry.fat == nil ? State(initialValue: nil) : State(initialValue: (entry.fat as! Int))
        _sugar = entry.sugar == nil ? State(initialValue: nil) : State(initialValue: (entry.sugar as! Int))
        entryToEdit = entry
    }
    
    init(){}
    
    var body : some View{
        Form{
            TextField("Name", text: self.$name)
            MultilineTextField("Description", text:self.$definition )
            HStack{
                IntegerInput(label:"Portion", value: self.$servingSize)
                Picker(selection: $servingUnit, label: Text("Unit")) {
                    ForEach(Units.onlyUnits(), id: \.self) { unit in
                        Text(unit.abbreviation).tag(unit as Units?)
                    }
                }
            }
            IntegerInput(label:"Calories", value: self.$calories)
            IntegerInput(label:"Protien", value: self.$protien)
            IntegerInput(label:"Carbs", value: self.$carbs)
            IntegerInput(label:"Fat", value: self.$fat)
            IntegerInput(label:"Sugar", value: self.$sugar)
            Button(action : {
                let dictionaryEntry = self.entryToEdit ?? DictionaryEntry(context: self.managedObjectContext)
                
                dictionaryEntry.name = self.name
                dictionaryEntry.definition = self.definition
                dictionaryEntry.servingSize = self.servingSize == nil ? nil : NSNumber(value: self.servingSize ?? 0)
                dictionaryEntry.servingUnit = self.servingSize == nil ? nil : NSNumber(value: self.servingUnit!.rawValue)
                dictionaryEntry.calories = NSNumber(value: self.calories ?? 0)
                dictionaryEntry.protien = NSNumber(value: self.protien ?? 0)
                dictionaryEntry.carbs = NSNumber(value: self.carbs ?? 0)
                dictionaryEntry.fat = NSNumber(value: self.fat ?? 0)
                dictionaryEntry.sugar = NSNumber(value: self.sugar ?? 0)
                
                do{
                    try self.managedObjectContext.save()
                }catch{
                    print(error)
                }
                
                self.name = ""
                self.definition = ""
                self.servingUnit = nil
                self.servingSize = nil
                self.calories = nil
                self.protien = nil
                self.carbs = nil
                self.fat = nil
                self.sugar = nil
                
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text(self.entryToEdit == nil ? "Add" : "Edit")
            }
            Button(action:{self.showScanner = true}){
                Image(systemName: "camera")
            }
        }.sheet(isPresented: self.$showScanner){
            NutritionFactScanner(completion: {(args) in
                if(args == nil || args!.count == 0){
                    //Toast: No text found
                }
                else if(args!.count > 1){
                    //Toast: More than one document scanner
                }
                else{
                    let nutritionLabel = args![0].lowercased();
                    let servingInfo = nutritionLabel.getServingSizeInfo()
                    self.servingUnit = servingInfo != nil ? servingInfo!.1 : nil
                    self.servingSize = servingInfo != nil ? servingInfo!.0 : nil
                    self.calories = nutritionLabel.getSubstringAfter("calories")?.getFirstIntegerValue()
                    self.protien = nutritionLabel.getSubstringAfter("protein")?.getFirstIntegerValue()
                    self.carbs = nutritionLabel.getSubstringAfter("total carb")?.getFirstIntegerValue()
                    self.fat = nutritionLabel.getSubstringAfter("total fat")?.getFirstIntegerValue()
                    self.sugar = nutritionLabel.getSubstringAfter("total sugar")?.getFirstIntegerValue()
                }
            })
        }
    }
}
