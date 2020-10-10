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
            Form{
                Picker(selection: $vm.massUnit, label: Text("Default Mass Unit")) {
                    ForEach(Units.massUnits(), id: \.self) { unit in
                        Text(unit.abbreviation).tag(unit as Units?)
                    }
                }
                Picker(selection: $vm.volumeUnit, label: Text("Default Volume Unit")) {
                    ForEach(Units.volumeUnits(), id: \.self) { unit in
                        Text(unit.abbreviation).tag(unit as Units?)
                    }
                }
            }
            Text("Temp Buttons")
            VStack{
                Button(action:{self.vm.deleteOldEntries()}){Text("Delete Old Entries")}
                Button(action:{self.vm.deleteSettings()}){Text("Delete Settings")}

            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
