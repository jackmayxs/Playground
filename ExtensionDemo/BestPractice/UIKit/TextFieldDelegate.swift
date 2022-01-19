//
//  TextFieldDelegate.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/4/1.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		// Get latest text of the textfield.
		let currentText = textField.text ?? ""
		guard let stringRange = Range(range, in: currentText) else { return false }
		_ = currentText.replacingCharacters(in: stringRange, with: string)
		return true
	}
}
