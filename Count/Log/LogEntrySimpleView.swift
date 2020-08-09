//
//  LogEntryView.swift
//  Count
//
//  Created by Michael Phelan on 6/26/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct LogEntryView: View {
    var name:String = ""
    var calories:Double = 0
    var protien:Double = 0
    var entryDate:String = ""
    
    //Text("Calories: \(self.logEntries.map({$0.calories as! Double}).reduce(0.0, +), specifier: "%.0f") Protien: \(self.logEntries.map({$0.protien as! Double}).reduce(0.0, +), specifier: "%.0f")"))
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack(){
                Text(name)
                    .font(.headline)
                //HStack(){
                    Spacer()
                    Text("Calories: \(self.calories, specifier: "%.0f")")
                        .font(.caption)
                    Text("Protien: \(self.protien, specifier: "%.0f")")
                        .font(.caption)
                }
            }
        }
    }
}

struct LogEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LogEntryView()
    }
}
