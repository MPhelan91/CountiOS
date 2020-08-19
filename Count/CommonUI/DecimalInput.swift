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
            if(!ignoreStringSet && !stringRepresentation.hasSuffix(".")){
                //Only allow two decimal places in string
                self.ignoreStringSet = true
                self.stringRepresentation = stringRepresentation.roundDecimalString(2) ?? ""
                self.ignoreStringSet = false
                
                //Set Numeric Value based on entered string
                self.ignoreNumericSet = true
                self.numericRepresentation = Double(stringRepresentation)
                self.ignoreNumericSet = false
            }
        }
    }

    @Published var numericRepresentation : Double? = nil {
        didSet{
            if(!ignoreNumericSet){
                self.ignoreStringSet = true
                self.stringRepresentation = numericRepresentation != nil ? numericRepresentation!.roundDecimalString(2)! : ""
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
