//
//  UITextFieldPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/4/9.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UITextInput {
	
	/// Return text with marked text trimmed. Used specifically when you type in chinese with Pinyin.
	var unmarkedText: String? {
		guard let inputRange = textRange(from: beginningOfDocument, to: endOfDocument) else {
			return .none
		}
		guard var inputText = text(in: inputRange) else {
			return .none
		}
		guard let markedRange = markedTextRange else {
			return inputText
		}
		
		let location = offset(from: beginningOfDocument, to: markedRange.start)
		let lenghth = offset(from: markedRange.start, to: markedRange.end)
		
		let from = inputText.index(inputText.startIndex, offsetBy: location)
		let to = inputText.index(from, offsetBy: lenghth)
		
		inputText.removeSubrange(from ..< to)
		return inputText
	}
}
