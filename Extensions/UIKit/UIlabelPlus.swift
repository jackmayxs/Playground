//
//  UIlabelPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/6/2.
//  Copyright © 2022 Choi. All rights reserved.
//

import UIKit

extension UILabel {
	
	// MARK: - __________ 快速创建方法 __________
	convenience init(
		text: String?,
		textColor: UIColor? = nil,
		fontSize: Double = 12.0,
		fontWeight: UIFont.Weight = .regular) {
			let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
			self.init(text: text, textColor: textColor, font: font)
		}
	
	convenience init(
		text: String?,
		textColor: UIColor? = nil,
		font: UIFont = .systemFont(ofSize: 12, weight: .regular)) {
			self.init(frame: .zero)
			self.text = text
			self.textColor = textColor ?? .darkText
			self.font = font
		}
}
