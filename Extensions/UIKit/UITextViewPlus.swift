//
//  UITextViewPlus.swift
//  KnowLED
//
//  Created by Choi on 2024/10/18.
//

import UIKit

extension UITextView {
    
    // Note: This will trigger a text rendering!
    var calculateViewHeightWithCurrentWidth: CGFloat {
        let textWidth = frame.width -
        textContainerInset.left -
        textContainerInset.right -
        textContainer.lineFragmentPadding * 2.0 -
        contentInset.left -
        contentInset.right
        
        let maxSize = CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude)
        let tmpAttributedString: NSAttributedString
        if let attributedText, attributedText.length > 0 {
            tmpAttributedString = attributedText
        } else {
            tmpAttributedString = NSAttributedString(string: text.orEmpty, attributes: typingAttributes)
        }
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        var calculatedSize = tmpAttributedString.boundingRect(with: maxSize, options: options, context: nil).size
        calculatedSize.height += textContainerInset.top
        calculatedSize.height += textContainerInset.bottom
        return ceil(calculatedSize.height)
    }
}
