//
//  ContentView.swift
//  Count
//
//  Created by Michael Phelan on 6/25/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            LogView()
                .tabItem{
                    Image(systemName: "list.bullet")
                    Text("Calorie Log")
            }
            DictionaryView()
                .tabItem{
                    Image(systemName: "book.circle")
                    Text("Dictionary")
            }
            SettingsView()
                .tabItem{
                    Image(systemName: "gear")
                    Text("Settings")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
