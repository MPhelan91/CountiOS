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

    @Published var stringRepresentation = "" {
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
    
    init(_ numericRepresentation: Double?){
        self.numericRepresentation = numericRepresentation
    }
}

struct DecimalInput:View{
    @Binding var value: Double?
    @ObservedObject var vm : DecimalInputVM
    var onFinishedEditing: (() -> Void)?
    var label: String
    
    init(label: String, value: Binding<Double?>, onFinishedEditing: (() -> Void)?) {
        self._value = value
        self.onFinishedEditing = onFinishedEditing
        self.label = label
        self._vm = ObservedObject(wrappedValue: DecimalInputVM(value.wrappedValue))
    }
    
    var body: some View{
        return HStack{
            Text("\(label): ")
            TextField("", text: self.$vm.stringRepresentation, onEditingChanged: {x in self.updateBinding(x)})
                .keyboardType(.decimalPad)
            Button(action: {self.hideKeyboard()}){
                Image(systemName: "checkmark")
            }
        }
    }
    
    private func updateBinding(_ editingChangedBool:Bool){
        if(!editingChangedBool){
            self.value = self.vm.numericRepresentation
            if(self.onFinishedEditing != nil) {self.onFinishedEditing!()}
        }
    }
}
