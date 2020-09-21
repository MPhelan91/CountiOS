//
//  LogHeaderView.swift
//  Count
//
//  Created by Michael Phelan on 9/18/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct LogHeaderView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var logEntries : [LogEntry]
    
    func sumValues(_ macroType:Macros) -> Double {
        switch macroType {
        case Macros.Calories:
            return self.logEntries.map({$0.calories as! Double}).reduce(0.0, +)
        case Macros.Protien:
            return self.logEntries.map({$0.protien as! Double}).reduce(0.0, +)
        default:
            return 0.0
        }
    }
    
    var body: some View {
        HStack{
            Spacer()
            VStack{
                MacroCountView(label: "Calories", total: sumValues(.Calories), goal: 2800)
                Spacer().frame(height:10)
                MacroCountView(label: "Fat", total: 40, goal: 77)
            }
            Spacer()
            VStack{
                MacroCountView(label: "Protien", total: sumValues(.Protien), goal: 180)
                Spacer().frame(height:10)
                MacroCountView(label: "Carb", total: 200, goal: 325)
            }
            Spacer()
        }
        .frame(height: 65)
        .background(colorScheme == .dark ? darkModeGray : lightModeGray)
        //.background(Color(red: 240 / 255, green: 237 / 255, blue: 237 / 255))
    }
}

struct MacroCountView : View{
    var label : String
    var total : Double
    var goal : Int

    var body: some View{
        HStack(spacing: 5){
            Text("\(label): \(total,specifier: "%.0f")").font(.headline)
            Text("/ \(goal.description)").fontWeight(.light).font(.caption)
        }
    }
}

struct LogHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LogHeaderView(logEntries: [])
    }
}
