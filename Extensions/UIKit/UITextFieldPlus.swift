//
//  UITextFieldPlus.swift
//  zeniko
//
//  Created by Choi on 2022/12/1.
//

import UIKit

extension UITextField {
    
    struct Associated {
        static var placeholderColor = UUID()
    }
    
    public var placeholderColor: UIColor {
        
        get {
            objc_getAssociatedObject(self, &Associated.placeholderColor) as! UIColor
        }
        
        set {
            objc_setAssociatedObject(self, &Associated.placeholderColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: newValue,
                .font: font ?? .systemFont(ofSize: 12)
            ]
            attributedPlaceholder = NSMutableAttributedString(string: placeholder ?? "", attributes: attributes)
        }
    }
}
