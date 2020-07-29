//
//  ExtensionButton.swift
//  
//
//  Created by Choi on 2020/7/22.
//

import UIKit

extension UIButton {
    
    enum ImageTitleStyle: Int {
        case ㊤㊦
        case ㊧㊨
        case ㊦㊤
        case ㊨㊧
    }
    
    private struct AssociatedObjectKeys {
        static var ImageTitleSpacingKey = "ImageTitleSpacingKey"
        static var ImageTitleStyleKey = "ImageTitleStyleKey"
    }
    
    // MARK: - Properties
    
    private(set) var imageTitleStyle: ImageTitleStyle {
        set(style) {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.ImageTitleStyleKey, style.rawValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            guard let rawValue = objc_getAssociatedObject(self, &AssociatedObjectKeys.ImageTitleStyleKey) as? Int else {
                return .㊧㊨
            }
            return ImageTitleStyle(rawValue: rawValue)!
        }
    }
    
    private(set) var spacing: CGFloat {
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.ImageTitleSpacingKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            objc_getAssociatedObject(self, &AssociatedObjectKeys.ImageTitleSpacingKey) as? CGFloat ?? 0
        }
    }
    
    var imageWidth: CGFloat { imageView?.image?.size.width ?? 0 }
    
    var imageHeight: CGFloat { imageView?.image?.size.height ?? 0 }
    
    var titleWidth: CGFloat {
        if #available(iOS 8.0, *) {
            return titleLabel?.intrinsicContentSize.width ?? 0
        } else {
            return titleLabel?.frame.size.width ?? 0
        }
    }
    
    var titleHeight: CGFloat {
        if #available(iOS 8.0, *) {
            return titleLabel?.intrinsicContentSize.height ?? 0
        } else {
            return titleLabel?.frame.size.height ?? 0
        }
    }
    
    /// 可以根据contentEdgeInsets自动适配自身大小
    open override var intrinsicContentSize: CGSize {

        var intrinsicWidth: CGFloat = 0.0
        var intrinsicHeight: CGFloat = 0.0

        // 计算按钮宽高
        switch imageTitleStyle  {
        case .㊤㊦, .㊦㊤:
            intrinsicWidth = max(imageWidth, titleWidth)
            intrinsicHeight = imageHeight + spacing + titleHeight
        case .㊧㊨, .㊨㊧:
            intrinsicWidth = imageWidth + spacing + titleWidth
            intrinsicHeight = max(imageHeight, titleHeight)
        }

        return CGSize(width: intrinsicWidth, height: intrinsicHeight) << contentEdgeInsets
    }
    
    // MARK: - Interface
    
    /// 调整ImageTitle样式
    /// - Parameters:
    ///   - style: 样式
    ///   - spacing: Image-Title间距(大于等于0)
    func adjustImageTitleStyle(_ style: ImageTitleStyle, spacing: CGFloat = 0) {
        
        assert(spacing >= 0, "A sane person will never do that🤪,right?")
        
        // 赋值
        self.imageTitleStyle = style
        self.spacing = spacing
        
        // 声明
        var imageEdgeInsets: UIEdgeInsets = .zero
        var titleEdgeInsets: UIEdgeInsets = .zero
        
        /// 根据ContentVerticalAlignment和ContentHorizontalAlignment
        /// 以及ImageTitleStyle确定最终的Image/Title的EdgeInsets
        /// - 说明:
        ///  - 平时使用最多的就是水平和垂直方向都居中的情况了,其他情况只为了加深印象
        switch (contentVerticalAlignment, contentHorizontalAlignment) {
        case (.center, .center):
            switch style {
            case .㊤㊦:
                imageEdgeInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: 0, right: -titleWidth)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-spacing, right: 0)
            case .㊧㊨:
                let offset = spacing/2
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -offset, bottom: 0, right: offset)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: -offset)
            case .㊦㊤:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
                titleEdgeInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: 0, right: 0)
            case .㊨㊧:
                let imageOffset = titleWidth + spacing/2
                let titleOffset = imageWidth + spacing/2
                imageEdgeInsets = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: -imageOffset)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -titleOffset, bottom: 0, right: titleOffset)
            }
        case (.top, .left):
            switch style {
            case .㊤㊦:
                titleEdgeInsets = UIEdgeInsets(top: imageHeight+spacing, left: -imageWidth, bottom: 0, right: 0)
            case .㊧㊨:
                titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
            case .㊦㊤:
                imageEdgeInsets = UIEdgeInsets(top: titleHeight+spacing, left: 0, bottom: -titleHeight-spacing, right: 0)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
            case .㊨㊧:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth+spacing, bottom: 0, right: -titleWidth-spacing)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
            }
        case (.top, .right):
            switch style {
            case .㊤㊦:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
                titleEdgeInsets = UIEdgeInsets(top: imageHeight+spacing, left: -imageWidth-spacing, bottom: 0, right: 0)
            case .㊧㊨:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
            case .㊦㊤:
                imageEdgeInsets = UIEdgeInsets(top: titleHeight+spacing, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
            case .㊨㊧:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-spacing, bottom: 0, right: imageWidth+spacing)
            }
        case (.bottom, .left):
            switch style {
            case .㊤㊦:
                imageEdgeInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: titleHeight+spacing, right: 0)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
            case .㊧㊨:
                titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
            case .㊦㊤:
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: imageHeight+spacing, right: 0)
            case .㊨㊧:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth+spacing, bottom: 0, right: -titleWidth-spacing)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
            }
        case (.bottom, .right):
            switch style {
            case .㊤㊦:
                imageEdgeInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: titleHeight+spacing, right: -titleWidth)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
            case .㊧㊨:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
            case .㊦㊤:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
                titleEdgeInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: imageHeight+spacing, right: 0)
            case .㊨㊧:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-spacing, bottom: 0, right: imageWidth+spacing)
            }
        default:
            break
        }
        
        // 赋值
        self.titleEdgeInsets = titleEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
        invalidateIntrinsicContentSize()
    }
}

extension CGSize {
    static func << (lhs: CGSize, rhs: UIEdgeInsets) -> CGSize {
        var output = lhs
        output.width += rhs.left + rhs.right
        output.height += rhs.top + rhs.bottom
        return output
    }
}
