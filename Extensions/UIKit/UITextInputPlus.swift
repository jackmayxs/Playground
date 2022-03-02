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
		guard let inputTextRange = textRange(from: beginningOfDocument, to: endOfDocument) else { return nil }
		guard let inputText = text(in: inputTextRange) else { return nil }
		guard let markedTextRange = markedTextRange else {
			return inputText
		}
		guard
			let headTextRange = textRange(from: beginningOfDocument, to: markedTextRange.start),
			let tailTextRange = textRange(from: markedTextRange.end, to: endOfDocument)
		else {
			return inputText
		}
		
		let headText = text(in: headTextRange) ?? ""
		let tailText = text(in: tailTextRange) ?? ""
		return headText + tailText
	}
}
