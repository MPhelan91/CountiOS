//
//  SettingsView.swift
//  Count
//
//  Created by Michael Phelan on 7/22/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings : SettingsVM
    @EnvironmentObject var clipBoard : ClipBoardImpl


    var body: some View {
        VStack{
            Form{
                Picker(selection: $settings.massUnit, label: Text("Default Mass Unit")) {
                    ForEach(Units.massUnits(), id: \.self) { unit in
                        Text(unit.abbreviation).tag(unit as Units?)
                    }
                }
                Picker(selection: $settings.volumeUnit, label: Text("Default Volume Unit")) {
                    ForEach(Units.volumeUnits(), id: \.self) { unit in
                        Text(unit.abbreviation).tag(unit as Units?)
                    }
                }
                MacroPicker(macroGoals: self.$settings.macroGoals)
                NavigationLink(destination: EntrySchedulerView()){
                    Text("Scheduled Entries")
                }
                Button(action:{
                    self.clipBoard.deleteClipBoard()
                }){
                    Text("Clear Clipboard")
                }.disabled(self.clipBoard.clipBoard.count == 0)
                NavigationLink(destination: AboutView()){
                    Text("About")
                }
            }
        }
        .navigationBarTitle(Text("Settings"))

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
