//
//  DecimalInput.swift
//  Count
//
//  Created by Michael Phelan on 8/15/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI
import Combine

class DecimalInputVM : ObservableObject {
    
    private var ignoreNumericSet = false
    private var ignoreStringSet = false

    @Published var stringRepresentation = ""{
        didSet{
            if(!ignoreStringSet){
                self.ignoreNumericSet = true
                
                //Validate
                if let newValue = Double(stringRepresentation) {
                    self.numericRepresentation = newValue
                }
                else{
                    self.numericRepresentation = nil
                }
                
                self.ignoreNumericSet = false
            }
        }
    }

    @Published var numericRepresentation : Double? = nil {
        didSet{
            if(!ignoreNumericSet){
                self.ignoreStringSet = true
                self.stringRepresentation = numericRepresentation != nil ? numericRepresentation!.description : ""
                self.ignoreStringSet = false
            }
        }
    }
}

struct DecimalInput:View{
    @ObservedObject var vm = DecimalInputVM()
    @Binding var value: Double
    
    var body: some View{
        HStack{
            TextField("", text: self.$vm.stringRepresentation, onEditingChanged: {x in self.updateBinding(x)})
                .keyboardType(.decimalPad)
            Button(action: {self.hideKeyboard()}){
                Image(systemName: "checkmark")
            }
        }.onAppear {
            self.vm.numericRepresentation = self.value
        }
    }
    
    private func updateBinding(_ finishedEditing:Bool){
        self.value = self.vm.numericRepresentation ?? 0.0
    }
}
