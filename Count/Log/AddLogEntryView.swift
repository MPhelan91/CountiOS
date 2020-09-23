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
                    DecimalInput(label: "Serving Size", value: $vm.servingSize, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Portion)})
                    Picker(selection: $vm.servingUnit, label: Text("Unit")) {
                        ForEach(Units.allCases, id: \.self) { unit in
                            Text(unit.abbreviation).tag(unit as Units?)
                        }
                    }
                }
            }
            Section(header: Text("New Entry")){
                Group{
                    TextField("Name", text: $vm.name)
                    DecimalInput(label: "Calories", value: $vm.calories, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Calorie)})
                    DecimalInput(label: "Protien", value: $vm.protien, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Protien)})
                    DecimalInput(label: "Fat", value: $vm.fat, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Fat)})
                    DecimalInput(label: "Carbs", value: $vm.carbs, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Carbs)})
                    DecimalInput(label: "Sugar", value: $vm.sugar, onFinishedEditing: {self.vm.RecalcNutrition(ChangedData.Sugar)})
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
