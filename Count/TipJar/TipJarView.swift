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

    var body: some View{
        VStack{
            HStack{
                Spacer(minLength: 20)
                VStack{
                    Text("Hey There!").frame(minWidth:0, maxWidth: .infinity, alignment: .leading)
                    Spacer().frame(maxHeight:30)
                    Text("          I'm just some guy who made an app to streamline my diet tracking, and I figured I'd share it.  Help me make it better by requesting new features or reporting bugs to count.contact.us@gmail.com.  If you like it, feel free to donate below!").lineLimit(nil)
                    Spacer().frame(maxHeight:30)
                    Text("~ Some Guy").frame(minWidth:0, maxWidth: .infinity, alignment: .trailing)
                    Spacer()
                }
                Spacer(minLength: 20)
            }
            List{
                ForEach(self.tipJarVM.tipOptions){ tipOption in
                    Button(action: {
                        self.tipJarVM.tip(tipOption)
                    }){
                        HStack{
                            Text(tipOption.product.localizedTitle)
                            Spacer()
                            Text(tipOption.product.price.description)

                        }
                    }
                }
            }
        }
        .alert(isPresented: self.$tipJarVM.showAlert) {
            Alert(title: Text("Thank You!"), message: Text(self.tipJarVM.alertMessage), dismissButton: .default(Text("Close")))
        }
    }
}
