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
    var entryDate:String = ""
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(name)
                    .font(.headline)
                Text(entryDate)
                    .font(.caption)
            }
        }
    }
}

struct LogEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LogEntryView()
    }
}
