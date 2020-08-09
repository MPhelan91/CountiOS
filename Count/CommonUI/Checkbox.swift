//
//  Checkbox.swift
//  Count
//
//  Created by Michael Phelan on 8/9/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct Checkbox:View{
    @State var isChecked = false;

    var body : some View{
        Button(action:{self.isChecked = !self.isChecked}){
            Image(systemName: isChecked ? "checkmark.square": "square")
        }
    }
}
