//
//  LogView.swift
//  Count
//
//  Created by Michael Phelan on 7/22/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct LogView: View {
    @State private var ysys = 0.0
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
    @EnvironmentObject var vm : LogVM
    
    func dateToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: vm.dateForCurrentEntries)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Image(systemName: "ellipsis").contextMenu{
                    Button("Copy to Today",action:{
                        if(self.vm.copySelected()){
                            self.toastMessage = "Copied to Today"
                            self.showToast = true
                        }
                    })
                }
                HStack{
                     Button(action:{self.vm.decrementDay()}){
                         Text("<")
                     }
                     Text(self.dateToString())
                     Button(action:{self.vm.incrementDay()}){
                         Text(">")
                     }
                 }
                List{
                    Section(header: Text("Calories: \(self.vm.logEntries.map({$0.calories as! Double}).reduce(0.0, +), specifier: "%.0f") Protien: \(self.vm.logEntries.map({$0.protien as! Double}).reduce(0.0, +), specifier: "%.0f")")){
                        ForEach(self.vm.logEntries){ logEntry in
                            LogEntrySimpleView(logEntry: logEntry)
                        }.onDelete { indexSet in
                            self.vm.deleteEntry(index: indexSet.first!)
                        }
                    }
                }
                .navigationBarTitle(Text("Log"))
                .navigationBarItems(
                    trailing: HStack{
                        NavigationLink(destination: AddLogEntryView(), tag: 1, selection: $action) {
                            Button(action: {self.action = 1}){
                                Image(systemName: "plus")
                            }
                        }
                    }
                )
            }
            }.toast(isShowing: self.$showToast, text: Text(self.toastMessage))
    }
}
