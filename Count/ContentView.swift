//
//  ContentView.swift
//  Count
//
//  Created by Michael Phelan on 6/25/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: LogEntry.getAllLogEntries()) var logEntries:FetchedResults<LogEntry>
        
    @State private var newLogEntry = ""
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("Calorie Log")){
                    HStack{
                        TextField("Entry Name", text: self.$newLogEntry)
                        Button(action : {
                            let logEntry = LogEntry(context: self.managedObjectContext)
                            logEntry.name = self.newLogEntry
                            logEntry.entryDate = Date()
                            
                            do{
                                try self.managedObjectContext.save()
                            }catch{
                                print(error)
                            }
                            
                            self.newLogEntry = ""
                        }){
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }.font(.headline)
                Section(header: Text("Log")){
                    ForEach(self.logEntries){ logEntry in
                        //Force unwrap => propertyNAme !
                        LogEntryView(name: logEntry.name!, entryDate: "\(logEntry.entryDate!)")
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
    .navigationBarTitle(Text("My List"))
    .navigationBarItems(trailing: EditButton())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
