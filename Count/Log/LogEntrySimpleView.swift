//
//  LogEntryView.swift
//  Count
//
//  Created by Michael Phelan on 6/26/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI
import CoreData

struct LogEntrySimpleView: View {
    @EnvironmentObject var vm : LogVM
    
    var logEntry:LogEntry
    var macros:[Macros]
    
    func getMacroAmount(_ macro: Macros) -> Double{
        switch(macro){
        case Macros.Calories:
            return (self.logEntry.calories ?? 0) as! Double
        case Macros.Protien:
            return (self.logEntry.protien ?? 0) as! Double
        case Macros.Fat:
            return (self.logEntry.fat ?? 0) as! Double
        case Macros.Carbs:
            return (self.logEntry.carbs ?? 0) as! Double
        case Macros.Sugar:
            return (self.logEntry.sugar ?? 0) as! Double
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(){
                Image(systemName: vm.isSelected(objectId: self.logEntry.objectID) ? "checkmark.square": "square")
                Text(self.logEntry.name ?? "")
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            HStack{
                Spacer()
                ForEach(self.macros, id:\.self){ macro in
                    Text("\(macro.getString): \(getMacroAmount(macro), specifier: "%.0f")")
                        .font(.caption)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            let isChecked = self.vm.isSelected(objectId: self.logEntry.objectID)
            if(!isChecked){
                self.vm.selelctEntry(objectId: self.logEntry.objectID)
            }
            else if(isChecked) {
                self.vm.unselectEntry(objectId: self.logEntry.objectID)
            }
        }
    }
}
