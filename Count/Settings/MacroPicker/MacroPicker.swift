//
//  MacroPicker.swift
//  Count
//
//  Created by Michael Phelan on 10/13/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI


class MacroGoal: Identifiable{
    var macro:Macros
    var goal:Int?
    
    init(_ macro: Macros, _ goal: Int) {
        self.macro = macro
        self.goal = goal
    }
}

struct MacroPicker:View{
    @Binding var macroGoals: [MacroGoal]
    
    init(macroGoals: Binding<[MacroGoal]>) {
        self._macroGoals = macroGoals
    }
    
    var body: some View{
        return NavigationLink(destination: MacroTable(macroGoals: self.$macroGoals)){
            Text("Macros")
            Spacer()
            Text(self.macroGoals.filter({$0.goal != nil && $0.goal! > 0}).map({$0.macro.getFullName}).joined(separator: ", "))
                .foregroundColor(Color.systemGray)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct MacroTable:View{
    @Binding var macroGoals: [MacroGoal]

    var body: some View{
        return List{
            ForEach(self.macroGoals.indices){ idx in
                HStack{
                    IntegerInput(label: self.macroGoals[idx].macro.getFullName, value: self.$macroGoals[idx].goal)
                    if(self.macroGoals[idx].macro != .Calories){
                        Text("grams ")
                    }
                }
            }
        }
    }
}
