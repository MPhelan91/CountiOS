//
//  AddLogEntryView.swift
//  Count
//
//  Created by Michael Phelan on 8/8/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI
import CoreData

struct AddLogEntryView : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var entryVM : AddLogEntryVM
    @EnvironmentObject var logVM : LogVM
    @EnvironmentObject var settings : SettingsVM
    
    func getMacroBinding(_ macro:Macros) -> Binding<Double?>{
        switch macro {
        case Macros.Calories:
            return self.$entryVM.calories
        case Macros.Protien:
            return self.$entryVM.protien
        case Macros.Fat:
            return self.$entryVM.fat
        case Macros.Carbs:
            return self.$entryVM.carbs
        case Macros.Sugar:
            return self.$entryVM.sugar
        }
    }
    
    var body: some View{
        Form {
            NavigationLink(destination: DictionaryView(onEntryClick: {(entry) in
                self.entryVM.selectedEntry = entry
            })){
                Text("Add From Dictionary")
            }
            
            if(entryVM.selectedEntry != nil){
                HStack{
                    Text("Description: ")
                    Text(entryVM.definition).lineLimit(nil)
                }
                DecimalInput(label: "Servings", value: $entryVM.servings, onFinishedEditing: { self.entryVM.RecalcNutrition(ChangedData.NumberOfServings) })
                if(entryVM.selectedEntry?.servingSize != nil){
                    HStack{
                        DecimalInput(label: "Portion", value: $entryVM.servingSize, onFinishedEditing: {self.entryVM.RecalcNutrition(ChangedData.Portion)})
                        Picker(selection: $entryVM.servingUnit, label: Text("Unit")) {
                            ForEach(Units.onlyUnits(), id: \.self) { unit in
                                Text(unit.abbreviation).tag(unit as Units?)
                            }
                        }
                    }
                }
            }
            Section(header: Text("New Entry")){
                Group{
                    TextField("Name", text: $entryVM.name)
                    ForEach(self.settings.macrosCounted(), id:\.self){ macro in
                        DecimalInput(label: macro.getFullName, value: getMacroBinding(macro), onFinishedEditing: {self.entryVM.RecalcNutrition(ChangedData.MacroToChangedData(macro))})
                    }
                    Button(action: {
                        self.entryVM.addEntry(date:self.logVM.dateForCurrentEntries)
                        self.logVM.fetchEntries()
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Add")
                    }
                }
            }
        }
    }
}
