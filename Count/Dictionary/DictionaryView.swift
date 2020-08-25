//
//  DictionaryView.swift
//  Count
//
//  Created by Michael Phelan on 7/22/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct DictionaryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: DictionaryEntry.getAllDictionaryEntries()) var dictionaryEntries:FetchedResults<DictionaryEntry>
    @State private var action: Int? = 0
    @State private var filter = ""
    
    var filteredEntries : [DictionaryEntry] {
        return filter.isEmpty ? dictionaryEntries.map({$0}) : dictionaryEntries.filter({$0.name!.lowercased().contains(filter.lowercased())})
    }
    
    var onEntryClick : ((DictionaryEntry)->Void)?
    
    init(onEntryClick : ((DictionaryEntry) -> Void)? = nil){
        self.onEntryClick = onEntryClick
    }
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    Section(header: Text("Dictionary")){
                        HStack{
                            TextField("Filter", text:self.$filter)
                            Button(action:{self.filter = ""}){
                                Image(systemName: "xmark")
                            }
                        }
                        ForEach(self.filteredEntries){ entry in
                            if(self.onEntryClick == nil){
                                NavigationLink(destination: DictionaryEntryFullView(entry)){
                                    DictionaryEntrySimpleView(name: entry.name!,
                                                              calories: entry.calories as! Int,
                                                              protien: entry.protien as! Int
                                    )
                                }
                            } else{
                                Button(action: {
                                    self.onEntryClick!(entry)
                                    self.presentationMode.wrappedValue.dismiss()
                                }){
                                    DictionaryEntrySimpleView(name: entry.name!,
                                                              calories: entry.calories as! Int,
                                                              protien: entry.protien as! Int
                                    )
                                }
                            }
                        }.onDelete { indexSet in
                            let deleteItem = self.filteredEntries[indexSet.first!]
                            self.managedObjectContext.delete(deleteItem)
                            do{
                                try self.managedObjectContext.save()
                            }catch{
                                print(error)
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("Dictionary"))
                .navigationBarItems(trailing: HStack{
                    NavigationLink(destination: DictionaryEntryFullView(), tag: 1, selection: $action) {
                        EmptyView()
                    }
                    Button(action: {self.action = 1}){
                        Image(systemName: "plus")
                    }
                })
            }
        }
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}
