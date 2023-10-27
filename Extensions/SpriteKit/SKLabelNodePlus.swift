//
//  SKLabelNodePlus.swift
//
//  Created by Choi on 2023/8/30.
//

import UIKit
import SpriteKit

extension SKLabelNode {
    
    convenience init(text: String, textColor: UIColor = .white, fontSize: CGFloat, fontWeight: UIFont.Weight = .regular) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .foregroundColor: textColor
        ]
        let attrbutedString = NSAttributedString(string: text, attributes: attributes)
        self.init(attributedText: attrbutedString)
    }
    
    /// 更新文字
    /// - Parameters:
    ///   - text: 新文本
    ///   - textColor: 文本颜色
    ///   - fontSize: 字体大小
    ///   - fontWeight: 字重
    func updateAttributedText(_ text: String, textColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight = .regular) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .foregroundColor: textColor
        ]
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    /// 更新字体颜色
    /// - Parameter textColor: 新的字体颜色
    func updateAttributedTextColor(_ textColor: UIColor?) {
        guard let textColor else { return }
        guard let oldAttributedText = attributedText else { return }
        var updatedAttributes = oldAttributedText.attributes(at: 0, effectiveRange: nil)
        guard updatedAttributes.isNotEmpty else { return }
        updatedAttributes[.foregroundColor] = textColor
        attributedText = NSAttributedString(string: oldAttributedText.string, attributes: updatedAttributes)
    }
}
