//
//  NutritionalInfo.swift
//  Count
//
//  Created by Michael Phelan on 8/4/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation

struct NutritionalInfo{
    var NumberOfServings:Double = 0
    var PortionSize:Double? = nil
    var PortionUnit:Units? = nil
    var Calories:Double = 0
    var Protien:Double = 0
    var Carbs:Double = 0
    var Fat:Double = 0
    
    init(){}
    
    init(_ numberOfServings: Double, _ portionSize: Double?, _ poritionUnit: Units?, _ calories: Double, _ protien: Double, _ carbs: Double, _ fat: Double){
        self.NumberOfServings = numberOfServings
        self.PortionSize = portionSize
        self.PortionUnit = poritionUnit
        self.Calories = calories
        self.Protien = protien
        self.Carbs = carbs
        self.Fat = fat
    }
}
