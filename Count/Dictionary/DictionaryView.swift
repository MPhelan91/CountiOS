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
        VStack{
            NavigationLink(destination:DictionaryEntryFullView(), tag: 1, selection: $action){EmptyView()}
            List{
                Section{
                    HStack{
                        TextFieldWithFirstFocus(text:self.$filter, placeHolder:"Filter", isFirstResponder: self.onEntryClick != nil)
                        Button(action:{self.filter = ""}){
                            Image(systemName: "xmark")
                        }
                    }
                    ForEach(self.filteredEntries){ entry in
                        if(self.onEntryClick == nil){
                            NavigationLink(destination: DictionaryEntryFullView(entry)){
                                Text(entry.name!).font(.headline).truncationMode(.tail).lineLimit(1)
                            }
                        } else{
                            Button(action: {
                                self.onEntryClick!(entry)
                                self.presentationMode.wrappedValue.dismiss()
                            }){
                                Text(entry.name!).font(.headline).truncationMode(.tail).lineLimit(1)
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
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("Dictionary"))
            .navigationBarItems(trailing: self.onEntryClick == nil
                ? AnyView(HStack{
                    Button(action: {self.action = 1}){
                        Image(systemName: "plus").font(.system(size: 25, weight: .bold))
                    }
                })
                : AnyView(EmptyView())
            )
        }
    }
}


struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}
