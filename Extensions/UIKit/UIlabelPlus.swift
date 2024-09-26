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
		text: String? = nil,
		textColor: UIColor? = nil,
		fontSize: Double = 12.0,
		fontWeight: UIFont.Weight = .regular,
        alignment: NSTextAlignment = .left) {
			let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
			self.init(text: text, textColor: textColor, font: font)
            textAlignment = alignment
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

//MARK: -- 设置UILabel的行间距和字间距
extension UILabel {
    
    /// 设置UILabel的行间距和字间距
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - letterSpacing: 字间距
    func setLineSpacing(_ lineSpacing: CGFloat, letterSpacing: CGFloat = 0) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        attributedString.addAttribute(
            .kern,
            value: letterSpacing,
            range: NSRange(location: 0, length: attributedString.length)
        )
        self.attributedText = attributedString
    }
}
