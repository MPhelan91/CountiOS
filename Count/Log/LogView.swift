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
            
        @State private var entryName = ""
        @State private var protien = ""
        @State private var calories = ""
        
        var body: some View {
                List{
                    Section(header: Text("Calorie Log")){
                        VStack{
                    
                        HStack{
                            TextField("Entry Name", text: self.$entryName)
                            TextField("Calories", text: self.$calories)
                            TextField("Protien", text: self.$protien)
                            Button(action : {
                                let logEntry = LogEntry(context: self.managedObjectContext)

                                logEntry.name = self.entryName
                                logEntry.calories = NSDecimalNumber(string: self.calories)
                                logEntry.protien = NSDecimalNumber(string: self.protien)
                                logEntry.entryDate = Date()
                                
                                do{
                                    try self.managedObjectContext.save()
                                }catch{
                                    print(error)
                                }
                                
                                self.entryName = ""
                                self.calories = ""
                                self.protien = ""
                            }){
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                    .imageScale(.large)
                            }
                        }
                        }
                    }.font(.headline)
                    Section(header: Text("Calories: \(self.logEntries.map({$0.calories as! Double}).reduce(0.0, +), specifier: "%.0f") Protien: \(self.logEntries.map({$0.protien as! Double}).reduce(0.0, +), specifier: "%.0f")")){
                        ForEach(self.logEntries){ logEntry in
                            //Force unwrap => propertyNAme !
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


