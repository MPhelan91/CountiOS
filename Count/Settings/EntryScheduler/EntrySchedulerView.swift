//
//  EntrySchedulerView.swift
//  Count
//
//  Created by Michael Phelan on 10/23/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct EntrySchedulerView: View {
    @EnvironmentObject var entryVM : AddLogEntryVM
    @EnvironmentObject var schedulerVM : EntrySchedulerVM
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
    
    var body: some View {
        VStack{
            HStack{
                Button(action:{self.schedulerVM.previousDay()}){
                    Image(systemName: "chevron.left").font(.system(size: 15)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                }
                Text(self.schedulerVM.day.asString).font(.system(size:20)).frame(width:120)
                Button(action:{self.schedulerVM.nextDay()}){
                    Image(systemName: "chevron.right").font(.system(size: 15)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            }
            Spacer()
            List{
                ForEach(self.schedulerVM.logEntries){ logEntry in
                    LogEntrySimpleView(logEntry: logEntry, macros: [])
                        .contextMenu{
                            Button("Delete Selected",action:{
                                if(self.schedulerVM.performDeleteEntries()){
                                    self.toastMessage = "Deleted"
                                    self.showToast = true
                                }
                            })
                        }
                }.onDelete { indexSet in
                    self.schedulerVM.deleteEntry(index: indexSet.first!)
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

