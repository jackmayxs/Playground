//
//  UITextViewPlus.swift
//  KnowLED
//
//  Created by Choi on 2024/10/18.
//

import UIKit

extension UITextView {
    
    /// 根据当前bounds的宽度计算自然尺寸
    var naturalSizeForBoundsWidth: CGSize {
        naturalSizeFor(width: bounds.width)
    }
    
    /// 计算自然尺寸: 根据指定宽度 + 现有的文字算出一个不被压缩的尺寸
    /// - Parameter width: 指定view宽度
    /// - Returns: 新尺寸(匹配指定宽度, 并保证文字不隐藏, 也即TextView可以完全展示出所有文字)
    /// - 注: This will trigger a text rendering!
    func naturalSizeFor(width designatedWidth: CGFloat) -> CGSize {
        /// 文字可绘制的宽度
        let textAvailableWidth = designatedWidth -
        textContainerInset.horizontal -
        textContainer.lineFragmentPadding * 2.0 -
        contentInset.horizontal
        /// 文字绘制容器
        let containerSize = CGSize(width: textAvailableWidth, height: CGFloat.greatestFiniteMagnitude)
        /// 临时的属性字符串
        let targetString: NSAttributedString
        /// 如果当前的属性字符串非空则直接使用, 否则根据typingAttributes创建一个
        if let attributedText, attributedText.length > 0 {
            targetString = attributedText
        } else {
            targetString = NSAttributedString(string: text.orEmpty, attributes: typingAttributes)
        }
        /// 文字绘制选项
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        /// 计算绘制尺寸
        var calculatedSize = targetString.boundingRect(with: containerSize, options: options, context: nil).size
        /// 高度再加上竖向的边距
        calculatedSize.height += textContainerInset.vertical + contentInset.vertical
        /// 取ceil
        let naturalHeight = ceil(calculatedSize.height)
        /// 返回最终尺寸
        return CGSize(width: designatedWidth, height: naturalHeight)
    }
}
