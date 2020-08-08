//
//  ServingInfo.swift
//  Count
//
//  Created by Michael Phelan on 8/4/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import Foundation

struct ServingInfo{
    var Serving:Double
    var Unit:ServingUnit
    init(serving:Double, unit:ServingUnit){
        Serving = serving
        Unit = unit
    }
}
