//
//  SKLabelNodePlus.swift
//
//  Created by Choi on 2023/8/30.
//

import UIKit
import SpriteKit

extension SKLabelNode {
    convenience init(text: String, textColor: UIColor = .white, fontSize: CGFloat = 12.0, fontWeight: UIFont.Weight = .regular) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .foregroundColor: textColor
        ]
        let attrbutedString = NSAttributedString(string: text, attributes: attributes)
        self.init(attributedText: attrbutedString)
    }
}
