//
//  DecimalInput.swift
//  Count
//
//  Created by Michael Phelan on 8/15/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI
import Combine

struct FilterablePicker:View{
    @State var filter = ""
    @State var selectedEntry = ""
    
    private var entries = [] as [String]
    
    init(){
        entries.append("Scooby")
        entries.append("Dooby")
        entries.append("Hooby")
        entries.append("Doo")
        entries.append("Velma")
        entries.append("Shaggy")
        entries.append("Fred")
        entries.append("Daphne")

    }
    
    var filteredEntries : [String] {
        let x = entries.filter({$0.contains(filter)})
        return x
    }
    
    var body: some View{
        return VStack{
            List{
                ForEach(self.filteredEntries, id: \.self) { entry in
                      Text(entry)
                  }
            }
            TextField("YOGI", text: self.$filter)
            Picker(selection: $selectedEntry, label: EmptyView()) {
                ForEach(self.filteredEntries, id: \.self) { entry in
                    Text(entry).tag(entry)
                }
            }.labelsHidden()
        }
    }
}
