//
//  Multipicker.swift
//  Count
//
//  Created by Michael Phelan on 10/10/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

protocol IdentifiableAndEquitable: Hashable, Equatable {}

struct Multipicker<T:IdentifiableAndEquitable>:View{
    @Binding var selectedValues: [T]
    var values: [T]
    var label: String
    var stringAccesor: (T)->String
    
    init(label:String, selectedValues: Binding<[T]>, values:[T], stringAccesor: @escaping (T)->String) {
        self.label = label
        self._selectedValues = selectedValues
        self.stringAccesor = stringAccesor
        self.values = values
    }
    
    var body: some View{
        return NavigationLink(destination: MultipickerTable<T>(values: self.values, selectedValues: self.$selectedValues, stringAccesor: self.stringAccesor) ){
            Text(self.label)
            Spacer()
            Text(self.selectedValues.map({self.stringAccesor($0)}).joined(separator: ", "))
                .foregroundColor(darkModeGray)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct MultipickerTable<T:IdentifiableAndEquitable>:View{
    var values: [T]
    @Binding var selectedValues: [T]
    var stringAccesor: (T)->String
    
    func toggleSelection(_ value:T){
        if(isSelected(value)){
            selectedValues.removeAll{$0 == value}
        }
        else{
            selectedValues.append(value)
        }
    }
    
    func isSelected(_ value:T) -> Bool{
        return self.selectedValues.contains(value)
    }
    
    
    var body: some View{
        return List{
            ForEach(self.values, id: \.self){ value in
                HStack{
                    Text(self.stringAccesor(value))
                    Spacer()
                    Image(systemName: self.isSelected(value) ? "checkmark.square": "square")
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleSelection(value)
                }
            }
        }
    }
}
