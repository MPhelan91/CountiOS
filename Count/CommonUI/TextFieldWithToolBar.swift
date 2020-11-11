//
//  Test.swift
//  Count
//
//  Created by Michael Phelan on 10/4/20.
//  Copyright © 2020 MichaelPhelan. All rights reserved.
//

import SwiftUI

struct TextFieldWithToolBar: UIViewRepresentable {
    
    @Binding var text: String
    var onFinishedEditing: () -> Void
    var keyboardType: UIKeyboardType
    
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.delegate = context.coordinator
        textfield.keyboardType = keyboardType
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil);
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var onFinishedEditing: () -> Void

        init(text: Binding<String>, onFinishedEditing: @escaping () ->Void) {
            _text = text
            self.onFinishedEditing = onFinishedEditing
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                textField.selectAll(nil)
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            onFinishedEditing()
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    func makeCoordinator() -> TextFieldWithToolBar.Coordinator {
        return Coordinator(text: $text, onFinishedEditing: onFinishedEditing)
    }
}

extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }

}
