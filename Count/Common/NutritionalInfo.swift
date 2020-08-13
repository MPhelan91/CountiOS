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
    var PortionSize:Double = 0
    var PortionUnit:Units = Units.Gram
    var Calories:Double = 0
    var Protien:Double = 0
    
    init(){}
    
    init(_ numberOfServings: Double, _ portionSize: Double, _ poritionUnit: Units, _ calories: Double, _ protien: Double){
        self.NumberOfServings = numberOfServings
        self.PortionSize = portionSize
        self.PortionUnit = poritionUnit
        self.Calories = calories
        self.Protien = protien
    }
}
