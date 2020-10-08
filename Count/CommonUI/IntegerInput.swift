//
//  IntegerInput.swift
//  Count
//
//  Created by Michael Phelan on 8/15/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI
import Combine

class IntegerInputVM : ObservableObject {
    
    private var ignoreNumericSet = false
    private var ignoreStringSet = false

    @Published var stringRepresentation = "" {
        didSet{
            if(!ignoreStringSet){
                self.ignoreNumericSet = true
                self.numericRepresentation = Int(stringRepresentation) ?? nil
                self.ignoreNumericSet = false
            }
        }
    }

    @Published var numericRepresentation : Int? = nil {
        didSet{
            if(!ignoreNumericSet){
                self.ignoreStringSet = true
                self.stringRepresentation = numericRepresentation != nil ? numericRepresentation!.description : ""
                self.ignoreStringSet = false
            }
        }
    }
    
    init(_ numericRepresentation: Int?){
        self.numericRepresentation = numericRepresentation
    }
}

struct IntegerInput:View{
    @Binding var value: Int?
    @ObservedObject var vm : IntegerInputVM
    var onFinishedEditing: (() -> Void)?
    var label: String
    
    init(label: String, value: Binding<Int?>, onFinishedEditing: (() -> Void)? = nil) {
        self._value = value
        self.onFinishedEditing = onFinishedEditing
        self.label = label
        self._vm = ObservedObject(wrappedValue: IntegerInputVM(value.wrappedValue))
    }
    
    var body: some View{
        return HStack{
            Text("\(label): ")
            TextFieldWithToolBar(text: self.$vm.stringRepresentation, onFinishedEditing: self.updateBinding, keyboardType: .numberPad)
        }
    }
    
    private func updateBinding(){
        self.value = self.vm.numericRepresentation
        if(self.onFinishedEditing != nil) {self.onFinishedEditing!()}
    }
}
