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
    var calories:Decimal = 0
    var protien:Decimal = 0
    var entryDate:String = ""
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack(){
                Text(name)
                    .font(.headline)
                //HStack(){
                    Spacer()
                    Text("Calories:" + calories.description)
                        .font(.caption)
                    Text("Protien:"+protien.description)
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
