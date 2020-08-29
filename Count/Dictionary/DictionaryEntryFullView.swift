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
    
    @State private var name = ""
    @State private var definition = ""
    @State private var servingSize:Int? = nil
    @State private var servingUnit : Units? = nil
    @State private var calories:Int? =  nil
    @State private var protien:Int? =  nil
    
    private var entryToEdit : DictionaryEntry? = nil
    
    init(_ entry: DictionaryEntry) {
        _name = State(initialValue: entry.name!)
        _definition = State(initialValue: entry.definition!)
        _servingSize = entry.servingSize == nil ? State(initialValue: nil) : State(initialValue: (entry.servingSize as! Int))
        _servingUnit = entry.servingSize == nil ? State(initialValue: nil) : State(initialValue: Units(rawValue: entry.servingUnit as! Int) ?? Units.Gram)
        _calories = entry.calories == nil ? State(initialValue: nil) : State(initialValue: (entry.calories as! Int))
        _protien = entry.protien == nil ? State(initialValue: nil) : State(initialValue: (entry.protien as! Int))
        entryToEdit = entry
    }
    
    init(){}
    
    var body : some View{
            Form{
                TextField("Name", text: self.$name)
                MultilineTextField("Description", text:self.$definition )
                HStack{
                    IntegerInput(label:"Protion", value: self.$servingSize)
                    Picker(selection: $servingUnit, label: Text("Unit")) {
                        ForEach(Units.allCases, id: \.self) { unit in
                            Text(unit.abbreviation).tag(unit as Units?)
                        }
                    }
                }
                IntegerInput(label:"Calories", value: self.$calories)
                IntegerInput(label:"Protien", value: self.$protien)
                Button(action : {
                    let dictionaryEntry = self.entryToEdit ?? DictionaryEntry(context: self.managedObjectContext)
                    
                    dictionaryEntry.name = self.name
                    dictionaryEntry.definition = self.definition
                    dictionaryEntry.servingSize = self.servingSize == nil ? nil : NSNumber(value: self.servingSize ?? 0)
                    dictionaryEntry.servingUnit = self.servingSize == nil ? nil : NSNumber(value: self.servingUnit!.rawValue)
                    dictionaryEntry.calories = NSNumber(value: self.calories ?? 0)
                    dictionaryEntry.protien = NSNumber(value: self.protien ?? 0)
                    
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
                    
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text(self.entryToEdit == nil ? "Add" : "Edit")
                }
        }
    }
}
