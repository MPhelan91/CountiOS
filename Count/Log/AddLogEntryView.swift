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
                TextField("Name", text: $vm.name)
                TextField("Description", text: $vm.definition)
                TextField("Servings", text: $vm.servings)
                TextField("Serving Size", text: $vm.servingSize)
                Picker(selection: $vm.servingUnit, label: Text("Unit")) {
                    ForEach(ServingUnit.allCases, id: \.self) { unit in
                        Text(unit.abbreviation)
                    }
                }
                Group{
                    TextField("Name", text: $vm.name)
                    TextField("Calories", text: $vm.calories)
                    TextField("Protien", text: $vm.protien)
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
