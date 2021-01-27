//
//  AboutView.swift
//  Count
//
//  Created by Michael Phelan on 1/24/21.
//  Copyright © 2021 MichaelPhelan. All rights reserved.
//

import Foundation
import SwiftUI

struct AboutView: View {

    var body: some View {
        HStack{
            Spacer(minLength: 20)
            VStack{
                Spacer()
                Text("Hey There!").frame(minWidth:0, maxWidth: .infinity, alignment: .leading)
                Spacer().frame(maxHeight:30)
                Text("          I'm just some guy who made an app to streamline my diet tracking, and I figured I'd share it.  Help me make it better by requesting new features or reporting bugs to count.contact.us@gmail.com. Thanks for trying my app!").lineLimit(nil)
                Spacer().frame(maxHeight:30)
                Text("~ Some Guy").frame(minWidth:0, maxWidth: .infinity, alignment: .trailing)
                Spacer()
                Spacer()
            }
            Spacer(minLength: 20)

        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
