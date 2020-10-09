//
//  SettingsView.swift
//  Count
//
//  Created by Michael Phelan on 7/22/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm : SettingsVM

    var body: some View {
        VStack{
            Button(action: {self.vm.deleteOldEntries()}){
                Text("Delete Old Entries")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
