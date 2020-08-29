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
    @State private var servingSize = ""
    @State private var servingUnit : Units? = nil
    @State private var calories = ""
    @State private var protien = ""
    
    private var entryToEdit : DictionaryEntry? = nil
    
    init(_ entry: DictionaryEntry) {
        _name = State(initialValue: entry.name!)
        _definition = State(initialValue: entry.definition!)
        _servingSize = entry.servingSize == nil ? State(initialValue: "") : State(initialValue: entry.servingSize!.description)
        _servingUnit = entry.servingSize == nil ? State(initialValue: nil) : State(initialValue: Units(rawValue: entry.servingUnit as! Int) ?? Units.Gram)
        _calories = State(initialValue: entry.calories!.description)
        _protien = State(initialValue: entry.protien!.description)
        entryToEdit = entry
    }
    
    init(){}
    
    var body : some View{
            Form{
                TextField("Name", text: self.$name)
                MultilineTextField("Description", text:self.$definition )
                HStack{
                    TextField("Serving Size", text: self.$servingSize)
                    Picker(selection: $servingUnit, label: Text("Unit")) {
                        ForEach(Units.allCases, id: \.self) { unit in
                            Text(unit.abbreviation).tag(unit as Units?)
                        }
                    }
                }
                TextField("Calories", text: self.$calories)
                TextField("Protien", text: self.$protien)
                Button(action : {
                    let dictionaryEntry = self.entryToEdit ?? DictionaryEntry(context: self.managedObjectContext)
                    
                    dictionaryEntry.name = self.name
                    dictionaryEntry.definition = self.definition
                    dictionaryEntry.servingSize = self.servingSize.isEmpty ? nil : NSNumber(value: Int(self.servingSize) ?? 0)
                    dictionaryEntry.servingUnit = self.servingSize.isEmpty ? nil : NSNumber(value: self.servingUnit!.rawValue)
                    dictionaryEntry.calories = NSNumber(value: Int(self.calories) ?? 0)
                    dictionaryEntry.protien = NSNumber(value: Int(self.protien) ?? 0)
                    
                    do{
                        try self.managedObjectContext.save()
                    }catch{
                        print(error)
                    }
                    
                    self.name = ""
                    self.definition = ""
                    self.servingUnit = Units.Gram
                    self.servingSize = ""
                    self.calories = ""
                    self.protien = ""
                    
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text(self.entryToEdit == nil ? "Add" : "Edit")
                }
        }
    }
}
