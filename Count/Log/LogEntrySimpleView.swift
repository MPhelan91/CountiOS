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
    @EnvironmentObject var logVM : LogVM<FetcherForLogView>
    
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
                Image(systemName: logVM.isSelected(objectId: self.logEntry.objectID) ? "checkmark.square": "square")
                Text(self.logEntry.name ?? "")
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            HStack{
                Spacer()
                ForEach(self.macros, id:\.self){ macro in
                    Text("\(macro.getFullName): \(getMacroAmount(macro), specifier: "%.0f")")
                        .font(.caption)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            let isChecked = self.logVM.isSelected(objectId: self.logEntry.objectID)
            if(!isChecked){
                self.logVM.selelctEntry(objectId: self.logEntry.objectID)
            }
            else if(isChecked) {
                self.logVM.unselectEntry(objectId: self.logEntry.objectID)
            }
        }
    }
}
