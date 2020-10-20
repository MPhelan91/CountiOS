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
    var macroGoals : [MacroGoal]
    
    init(_ logEntries: [LogEntry], _ macroGoals : [MacroGoal]) {
        self.logEntries = logEntries
        self.macroGoals = macroGoals.filter({x in x.goal != nil && x.goal! > 0})
    }
    
    func sumValues(_ macroType:Macros) -> Double {
        switch macroType {
        case Macros.Calories:
            return self.logEntries.map({$0.calories as! Double}).reduce(0.0, +)
        case Macros.Protien:
            return self.logEntries.map({$0.protien as! Double}).reduce(0.0, +)
        case Macros.Fat:
            return self.logEntries.map({$0.fat as! Double}).reduce(0.0, +)
        case Macros.Carbs:
            return self.logEntries.map({$0.carbs as! Double}).reduce(0.0, +)
        case Macros.Sugar:
            return self.logEntries.map({$0.sugar as! Double}).reduce(0.0, +)
        }
    }
    
    var body: some View {
        if(self.macroGoals.count == 1){
            HStack{
                Spacer()
                MacroCountView(label: self.macroGoals[0].macro.getFullName, total: sumValues(self.macroGoals[0].macro), goal: self.macroGoals[0].goal!)
                Spacer()
            }
            .frame(height: 40)
            .background(colorScheme == .dark ? darkModeGray : lightModeGray)
        }
        else if(self.macroGoals.count == 2){
            HStack{
                Spacer()
                MacroCountView(label: self.macroGoals[0].macro.getFullName, total: sumValues(self.macroGoals[0].macro), goal: self.macroGoals[0].goal!)
                Spacer()
                MacroCountView(label: self.macroGoals[1].macro.getFullName, total: sumValues(self.macroGoals[1].macro), goal: self.macroGoals[1].goal!)
                Spacer()
            }
            .frame(height: 40)
            .background(colorScheme == .dark ? darkModeGray : lightModeGray)
        }
        else if(self.macroGoals.count == 3){
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    MacroCountView(label: self.macroGoals[0].macro.getFullName, total: sumValues(self.macroGoals[0].macro), goal: self.macroGoals[0].goal!)
                    Spacer()
                    MacroCountView(label: self.macroGoals[2].macro.getFullName, total: sumValues(self.macroGoals[2].macro), goal: self.macroGoals[2].goal!)
                    Spacer()
                }
                Spacer()
                MacroCountView(label: self.macroGoals[1].macro.getFullName, total: sumValues(self.macroGoals[1].macro), goal: self.macroGoals[1].goal!)
                Spacer()
            }
            .frame(height: 65)
            .background(colorScheme == .dark ? darkModeGray : lightModeGray)
        }
        else if(self.macroGoals.count == 4) {
            HStack{
                Spacer()
                VStack{
                    MacroCountView(label: self.macroGoals[0].macro.getFullName, total: sumValues(self.macroGoals[0].macro), goal: self.macroGoals[0].goal!)
                    Spacer().frame(height:10)
                    MacroCountView(label: self.macroGoals[2].macro.getFullName, total: sumValues(self.macroGoals[2].macro), goal: self.macroGoals[2].goal!)
                }
                Spacer()
                VStack{
                    MacroCountView(label: self.macroGoals[1].macro.getFullName, total: sumValues(self.macroGoals[1].macro), goal: self.macroGoals[1].goal!)
                    Spacer().frame(height:10)
                    MacroCountView(label: self.macroGoals[3].macro.getFullName, total: sumValues(self.macroGoals[3].macro), goal: self.macroGoals[3].goal!)
                }
                Spacer()
            }
            .frame(height: 65)
            .background(colorScheme == .dark ? darkModeGray : lightModeGray)
        }
        else if(self.macroGoals.count == 5){
            HStack{
                Spacer()
                VStack{
                    MacroCountView(label: self.macroGoals[0].macro.getShortName, total: sumValues(self.macroGoals[0].macro), goal: self.macroGoals[0].goal!)
                    Spacer().frame(height:10)
                    MacroCountView(label: self.macroGoals[2].macro.getShortName, total: sumValues(self.macroGoals[2].macro), goal: self.macroGoals[2].goal!)
                }
                Spacer()
                VStack{
                    MacroCountView(label: self.macroGoals[1].macro.getShortName, total: sumValues(self.macroGoals[1].macro), goal: self.macroGoals[1].goal!)
                    Spacer().frame(height:10)
                    MacroCountView(label: self.macroGoals[3].macro.getShortName, total: sumValues(self.macroGoals[3].macro), goal: self.macroGoals[3].goal!)
                }
                Spacer()
                MacroCountView(label: self.macroGoals[4].macro.getShortName, total: sumValues(self.macroGoals[4].macro), goal: self.macroGoals[4].goal!)
                Spacer()
            }
            .frame(height: 65)
            .background(colorScheme == .dark ? darkModeGray : lightModeGray)
        }
        else{
            EmptyView()
        }
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
        let macroGoals : [MacroGoal] = [
            MacroGoal(Macros.Calories, 2600),
            MacroGoal(Macros.Protien, 195),
            MacroGoal(Macros.Fat, 200),
            MacroGoal(Macros.Carbs, 600),
            MacroGoal(Macros.Sugar, 20),
        ]
        
        LogHeaderView([], macroGoals)
    }
}
