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
    
    var body: some View{
        NavigationView{
            Form {
                Picker(selection: $vm.dictionaryEntryName, label: Text("Dictionary")) {
                    ForEach(self.vm.dictionaryEntries, id: \.name) { entry in
                        Text(entry.name!).tag(entry.name)
                    }
                }
                TextField("Description", text: $vm.definition)
                DecimalInput(label: "Servings", value: $vm.servings, onFinishedEditing: { self.vm.RecalcNutrition(ChangedData.NumberOfServings) })
                DecimalInput(label: "Serving Size", value: $vm.servingSize, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Portion)})
                //Could not find onEditingChange equivelent for picker so using property observer of servingUnit in viewModel to recalc values on change
                Picker(selection: $vm.servingUnit, label: Text("Unit")) {
                    ForEach(Units.allCases, id: \.self) { unit in
                        Text(unit.abbreviation)
                    }
                }
                Group{
                    TextField("Name", text: $vm.name)
                    DecimalInput(label: "Calories", value: $vm.calories, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Calorie)})
                    DecimalInput(label: "Protien", value: $vm.protien, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Protien)})
                    Button(action: {
                        self.vm.addEntry(date:self.vm2.dateForCurrentEntries)
                        self.vm2.fetchEntries()
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Add")
                    }
                }
            }
        }.onAppear(perform:{self.vm.clearData()})
    }
}
