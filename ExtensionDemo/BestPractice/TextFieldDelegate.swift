//
//  TextFieldDelegate.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/4/1.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

class TextFieldDelegate: UIViewController, UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		do {
			// Do something when no text is marked.
			guard textField.markedTextRange == .none else {
				return true
			}
		}
		do {
			// Get latest text of the textfield.
			let currentText = textField.text ?? ""
			guard let stringRange = Range(range, in: currentText) else { return false }
			_ = currentText.replacingCharacters(in: stringRange, with: string)
		}
		return true
	}
}
