//
//  DictionaryView.swift
//  Count
//
//  Created by Michael Phelan on 7/22/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct DictionaryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: DictionaryEntry.getAllDictionaryEntries()) var dictionaryEntries:FetchedResults<DictionaryEntry>
    @State private var action: Int? = 0
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: DictionaryEntryFullView(), tag: 1, selection: $action) {
                    EmptyView()
                }
                Button(action: {self.action = 1}){
                    Text("Add Entry")
                }
                List{
                    Section(header: Text("Dictionary")){
                        ForEach(self.dictionaryEntries){ entry in
                            NavigationLink(destination: DictionaryEntryFullView(entry)){
                                DictionaryEntrySimpleView(name: entry.name,
                                             calories: entry.calories as! Int,
                                             protien: entry.protien as! Int
                                )
                            }
                        }.onDelete { indexSet in
                            let deleteItem = self.dictionaryEntries[indexSet.first!]
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

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}
