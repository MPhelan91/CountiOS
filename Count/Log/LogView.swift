//
//  LogView.swift
//  Count
//
//  Created by Michael Phelan on 7/22/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct LogView: View {
    @EnvironmentObject var vm2 : AddLogEntryVM
    @EnvironmentObject var vm : LogVM
    @EnvironmentObject var settings : SettingsVM
    @Environment(\.colorScheme) var colorScheme
    
    @State private var action: Int? = 0
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
        return dateFormatter.string(from: vm.dateForCurrentEntries)
    }
    
    var body: some View {
        VStack{
            HStack{
                Button(action:{self.vm.decrementDay()}){
                    Image(systemName: "arrowtriangle.left").font(.system(size: 15)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                }
                Text(self.dateToString()).font(.system(size:20))
                Button(action:{self.vm.incrementDay()}){
                    Image(systemName: "arrowtriangle.right").font(.system(size: 15)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            }
            Spacer()
            LogHeaderView(self.vm.logEntries, self.settings.macroGoals)
            List{
                ForEach(self.vm.logEntries){ logEntry in
                    LogEntrySimpleView(logEntry: logEntry, macros: self.settings.macrosCounted())
                        .contextMenu{
                            Button("Copy Selected to Today",action:{
                                if(self.vm.performCopySelected()){
                                    self.toastMessage = "Copied to Today"
                                    self.showToast = true
                                }
                            })
                            Button("Delete Selected",action:{
                                if(self.vm.performDeleteEntries()){
                                    self.toastMessage = "Deleted"
                                    self.showToast = true
                                }
                            })
                            Button("Make Dictionary Entry From Selected",action:{
                                self.toastMessage = "Not Implemented"
                                self.showToast = true
                            })
                        }
                }.onDelete { indexSet in
                    self.vm.deleteEntry(index: indexSet.first!)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("Log"))
            .navigationBarItems(
                trailing: HStack{
                    NavigationLink(destination: AddLogEntryView(), tag: 1, selection: $action) {
                        Button(action: {
                            self.vm2.clearData()
                            self.action = 1
                        }){
                            Image(systemName: "plus").font(.system(size: 25, weight: .bold))
                        }
                    }
                }
            )
        }.toast(isShowing: self.$showToast, text: Text(self.toastMessage))
    }
}
