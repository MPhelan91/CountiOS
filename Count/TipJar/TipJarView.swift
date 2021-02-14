//
//  TipJarView.swift
//  Count
//
//  Created by Michael Phelan on 2/14/21.
//  Copyright © 2021 MichaelPhelan. All rights reserved.
//

import SwiftUI
import StoreKit

struct TipJarView: View{
    @EnvironmentObject var tipJarVM : TipJarVM

    let tempList = ["a","b","c","d"]
    var body: some View{
        VStack{
            Text("Help support us! Anything Helps")
            List{
                ForEach(self.tipJarVM.tipOptions){ tipOption in
                    Button(action: {}){
                        HStack{
                            Text(tipOption.product.localizedTitle)
                            Spacer()
                            Text(tipOption.product.price.description)

                        }
                    }
                }
            }
        }
    }
}
