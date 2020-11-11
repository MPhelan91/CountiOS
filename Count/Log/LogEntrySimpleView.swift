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
    @EnvironmentObject var schedulerVM : LogVM<FetcherForScheduler>
    
    var logEntry:LogEntry
    var macros:[Macros]
    var isLogView:Bool
    
    init(_ entry:LogEntry, _ macros: [Macros], _ isLogView : Bool){
        self.logEntry = entry
        self.macros = macros
        self.isLogView = isLogView
    }
    
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
    
    func isSelected() -> Bool{
        if(self.isLogView){
            return logVM.isSelected(objectId: self.logEntry.objectID)
        }
        else{
            return schedulerVM.isSelected(objectId: self.logEntry.objectID)
        }
    }
    
    func select(){
        if(self.isLogView){
            self.logVM.selelctEntry(objectId: self.logEntry.objectID)
        }
        else{
            self.schedulerVM.selelctEntry(objectId: self.logEntry.objectID)
        }
    }
    
    func unselect(){
        if(self.isLogView){
            self.logVM.unselectEntry(objectId: self.logEntry.objectID)
        }
        else{
            self.schedulerVM.unselectEntry(objectId: self.logEntry.objectID)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(){
                Image(systemName: self.isSelected() ? "checkmark.square": "square")
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
            let isChecked = self.isSelected()
            if(!isChecked){
                self.select()
            }
            else if(isChecked) {
                self.unselect()
            }
        }
    }
}
