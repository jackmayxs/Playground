//
//  NSAttributedStringPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/7/24.
//

import UIKit

extension NSAttributedString {
    
    /// 计算文字的尺寸
    var bounds: CGRect {
        let preferredSize = CGSize(width: .max, height: .max)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        return boundingRect(with: preferredSize, options: options, context: nil)
    }
}
