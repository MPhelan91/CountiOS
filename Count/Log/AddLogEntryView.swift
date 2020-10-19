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
    @EnvironmentObject var vm : AddLogEntryVM
    @EnvironmentObject var vm2 : LogVM
    @EnvironmentObject var settings : SettingsVM
    
    func getMacroBinding(_ macro:Macros) -> Binding<Double?>{
        switch macro {
        case Macros.Calories:
            return self.$vm.calories
        case Macros.Protien:
            return self.$vm.protien
        case Macros.Fat:
            return self.$vm.fat
        case Macros.Carbs:
            return self.$vm.carbs
        case Macros.Sugar:
            return self.$vm.sugar
        }
    }
    
    var body: some View{
        Form {
            NavigationLink(destination: DictionaryView(onEntryClick: {(entry) in
                self.vm.selectedEntry = entry
            })){
                Text("Add From Dictionary")
            }
            
            if(vm.selectedEntry != nil){
                HStack{
                    Text("Description: ")
                    Text(vm.definition).lineLimit(nil)
                }
                DecimalInput(label: "Servings", value: $vm.servings, onFinishedEditing: { self.vm.RecalcNutrition(ChangedData.NumberOfServings) })
                if(vm.selectedEntry?.servingSize != nil){
                    HStack{
                        DecimalInput(label: "Portion", value: $vm.servingSize, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Portion)})
                        Picker(selection: $vm.servingUnit, label: Text("Unit")) {
                            ForEach(Units.onlyUnits(), id: \.self) { unit in
                                Text(unit.abbreviation).tag(unit as Units?)
                            }
                        }
                    }
                }
            }
            Section(header: Text("New Entry")){
                Group{
                    TextField("Name", text: $vm.name)
                    ForEach(self.settings.macrosCounted(), id:\.self){ macro in
                        DecimalInput(label: macro.getString, value: getMacroBinding(macro), onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.MacroToChangedData(macro))})
                    }
                    Button(action: {
                        self.vm.addEntry(date:self.vm2.dateForCurrentEntries)
                        self.vm2.fetchEntries()
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Add")
                    }
                }
            }
        }
    }
}
