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
                Text("Calories: \((self.logEntry.calories ?? 0) as Double, specifier: "%.0f")")
                    .font(.caption)
                Text("Protien: \((self.logEntry.protien ?? 0) as Double, specifier: "%.0f")")
                    .font(.caption)
                Text("Fat: \((0) as Double, specifier: "%.0f")")
                    .font(.caption)
                Text("Sugar: \((0) as Double, specifier: "%.0f")")
                    .font(.caption)
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
