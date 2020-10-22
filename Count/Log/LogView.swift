//
//  LogView.swift
//  Count
//
//  Created by Michael Phelan on 7/22/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct LogView: View {
    @EnvironmentObject var entryVM : AddLogEntryVM
    @EnvironmentObject var logVM : LogVM
    @EnvironmentObject var settings : SettingsVM
    @Environment(\.colorScheme) var colorScheme
    
    
    @State private var navSelection: String? = nil
    
    @State private var showToast = false{
        didSet{
            //TODO: try and do this in the Toast class itself
            if(self.showToast){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        self.showToast = false
                    }
                }
            }
        }
    }
    @State private var toastMessage = ""
    
    func dateToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: logVM.dateForCurrentEntries)
    }
    
    var body: some View {
        VStack{
            NavigationLink(destination:DictionaryEntryFullView(self.logVM.selectedEntries).onDisappear{self.logVM.selectedEntries.removeAll()}, tag: "Dictionary Entry", selection: $navSelection){EmptyView()}
            HStack{
                Button(action:{self.logVM.decrementDay()}){
                    Image(systemName: "arrowtriangle.left").font(.system(size: 15)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                }
                Text(self.dateToString()).font(.system(size:20))
                Button(action:{self.logVM.incrementDay()}){
                    Image(systemName: "arrowtriangle.right").font(.system(size: 15)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            }
            Spacer()
            LogHeaderView(self.logVM.logEntries, self.settings.macroGoals)
            List{
                ForEach(self.logVM.logEntries){ logEntry in
                    LogEntrySimpleView(logEntry: logEntry, macros: self.settings.macrosCounted())
                        .contextMenu{
                            Button("Copy Selected to Today",action:{
                                if(self.logVM.performCopySelected()){
                                    self.toastMessage = "Copied to Today"
                                    self.showToast = true
                                }
                            })
                            Button("Delete Selected",action:{
                                if(self.logVM.performDeleteEntries()){
                                    self.toastMessage = "Deleted"
                                    self.showToast = true
                                }
                            })
                            Button("Make Dictionary Entry From Selected",action:{
                                if(self.logVM.selectedEntries.count > 0){
                                    self.navSelection = "Dictionary Entry"
                                    //unselectValues? => or pass callback that clears it
                                }
                            })
                        }
                }.onDelete { indexSet in
                    self.logVM.deleteEntry(index: indexSet.first!)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("Log"))
            .navigationBarItems(
                trailing: HStack{
                    NavigationLink(destination: AddLogEntryView(), tag: "Add Entry", selection: $navSelection) {
                        Button(action: {
                            self.entryVM.clearData()
                            self.navSelection = "Add Entry"
                        }){
                            Image(systemName: "plus").font(.system(size: 25, weight: .bold))
                        }
                    }
                }
            )
        }.toast(isShowing: self.$showToast, text: Text(self.toastMessage))
    }
}
