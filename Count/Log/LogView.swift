//
//  LogView.swift
//  Count
//
//  Created by Michael Phelan on 7/22/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct LogView: View {
    @State private var action: Int? = 0
    
    @EnvironmentObject var vm : LogVM
    
    func dateToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: vm.dateForCurrentEntries)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: AddLogEntryView(), tag: 1, selection: $action) {
                    EmptyView()
                }
                Button(action: {self.action = 1}){
                    Text("Add Entry")
                }
                HStack{
                    Button(action:{self.vm.decrementDay()}){
                        Text("<")
                    }
                    Text(self.dateToString())
                    Button(action:{self.vm.incrementDay()}){
                        Text(">")
                    }
                }
                List{
                    Section(header: Text("Calories: \(self.vm.logEntries.map({$0.calories as! Double}).reduce(0.0, +), specifier: "%.0f") Protien: \(self.vm.logEntries.map({$0.protien as! Double}).reduce(0.0, +), specifier: "%.0f")")){
                        ForEach(self.vm.logEntries){ logEntry in
                            LogEntryView(name: logEntry.name!, calories: logEntry.calories! as! Double, protien: logEntry.protien! as! Double, entryDate: "\(logEntry.entryDate!)")
                        }.onDelete { indexSet in
                            self.vm.deleteEntry(index: indexSet.first!)
                        }
                    }
                }
            }
        }
    }
}


