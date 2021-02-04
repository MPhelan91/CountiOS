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
    @EnvironmentObject var settings : SettingsVM
    @EnvironmentObject var schedulerVM : LogVM<FetcherForScheduler>
    @EnvironmentObject var clipBoard : ClipBoardImpl
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
            NavigationLink(destination: AddLogEntryView(self.schedulerVM), tag: "Add Entry", selection: $navSelection) {EmptyView()}
            HStack{
                Button(action:{self.schedulerVM.previous()}){
                    Image(systemName: "chevron.left").font(.system(size: 15)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                }
                Text(self.schedulerVM.critAsString()).font(.system(size:20)).frame(width:120)
                Button(action:{self.schedulerVM.next()}){
                    Image(systemName: "chevron.right").font(.system(size: 15)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            }
            Spacer()
            LogHeaderView(self.schedulerVM.logEntries, self.settings.macroGoals)
            List{
                ForEach(self.schedulerVM.logEntries){ logEntry in
                    LogEntrySimpleView(logEntry, [], false)
                }.onDelete { indexSet in
                    self.schedulerVM.deleteEntry(index: indexSet.first!)
                }
                .contextMenu{
                    if(self.clipBoard.clipBoard.count > 0){
                        Button("Paste", action:{
                            if(self.schedulerVM.performAddEntries(self.clipBoard.clipBoard)){
                                self.toastMessage = "Pasted"
                                self.showToast = true
                            }
                        })
                    }
                    if(self.schedulerVM.selectedEntries.count > 0){
                        Button("Copy", action:{
                            self.clipBoard.copyToClipBoard(entries: self.schedulerVM.selectedEntries)
                            self.schedulerVM.deselectAllEntries()
                            self.toastMessage = "Copied"
                            self.showToast = true
                        })
                        Button("Delete",action:{
                            if(self.schedulerVM.performDeleteEntries()){
                                self.toastMessage = "Deleted"
                                self.showToast = true
                            }
                        })
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(Text("Scheduler"))
        .navigationBarItems(
            trailing: Button(action: {
                self.entryVM.clearData()
                self.navSelection = "Add Entry"
            }){
                Image(systemName: "plus").font(.system(size: 30, weight: .bold))
            }
        )
        .toast(isShowing: self.$showToast, text: Text(self.toastMessage))
    }
}

