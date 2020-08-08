//
//  LogView.swift
//  Count
//
//  Created by Michael Phelan on 7/22/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct LogView: View {
        @Environment(\.managedObjectContext) var managedObjectContext
        @FetchRequest(fetchRequest: LogEntry.getAllLogEntries()) var logEntries:FetchedResults<LogEntry>
        @State private var action: Int? = 0
            
        @State private var entryName = ""
        @State private var protien = ""
        @State private var calories = ""
        
        var body: some View {
            NavigationView{
                VStack{
                    NavigationLink(destination: AddLogEntryView(), tag: 1, selection: $action) {
                        EmptyView()
                    }
                    Button(action: {self.action = 1}){
                        Text("Add Entry")
                    }
                    List{
                        Section(header: Text("Calories: \(self.logEntries.map({$0.calories as! Double}).reduce(0.0, +), specifier: "%.0f") Protien: \(self.logEntries.map({$0.protien as! Double}).reduce(0.0, +), specifier: "%.0f")")){
                            ForEach(self.logEntries){ logEntry in
                                //Force unwrap => propertyNAme !
                                //LogEntryView(name: logEntry.name ?? "YARg")
                                LogEntryView(name: logEntry.name!, calories: logEntry.calories! as Decimal, protien: logEntry.protien! as Decimal, entryDate: "\(logEntry.entryDate!)")
                            }.onDelete { indexSet in
                                let deleteItem = self.logEntries[indexSet.first!]
                                self.managedObjectContext.delete(deleteItem)
                                
                                do{
                                    try self.managedObjectContext.save()
                                }catch{
                                    print(error)
                                }
                            }
                        }
                    }
                }
            }
        }
}


