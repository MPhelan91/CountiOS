//
//  UIExetnsions.swift
//  Count
//
//  Created by Michael Phelan on 8/10/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

extension View {

    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
