//
//  DictionaryEntryView.swift
//  Count
//
//  Created by Michael Phelan on 7/27/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct DictionaryEntrySimpleView : View{
    var name:String=""
    var definition:String=""
    var servingSize:Int=0
    var servingUnit:ServingUnit = ServingUnit.Gram
    var calories:Int=0
    var protien:Int=0
    
    var body:some View{
        HStack{
            VStack(alignment: .leading){
                HStack(){
                Text(name)
                    .font(.headline)
                //HStack(){
                    Spacer()
                    Text("Calories:" + calories.description)
                        .font(.caption)
                    Text("Protien:"+protien.description)
                        .font(.caption)
                }
            }
        }
    }
}
