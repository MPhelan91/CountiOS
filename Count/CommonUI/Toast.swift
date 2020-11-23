//
//  Toast.swift
//  Count
//
//  Created by Michael Phelan on 8/10/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct Toast<Presenting>: View where Presenting: View {
    
    @Binding var isShowing: Bool
    let presenting: () -> Presenting
    let text: Text
    
    var body: some View {
        
        return GeometryReader { geometry in
            
            ZStack(alignment: .center) {
                
                self.presenting().blur(radius: self.isShowing ? 1 : 0)
                
                VStack {
                    self.text
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 7)
                .background(Color.systemGray3)
                    .foregroundColor(Color.label)
                    .cornerRadius(20)
                    .transition(.slide)
                    .opacity(self.isShowing ? 1 : 0)
                
            }
            
        }
        
    }
}
