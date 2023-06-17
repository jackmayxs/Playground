//
//  UIScrollViewPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/6/17.
//

import UIKit

extension UIScrollView {

    
    /// 是否在指定的方向上隐藏滚动条
    /// - Parameter direction: 滚动方向
    /// - Returns: 是否隐藏滚动条
    func shouldHideScrollBar(at direction: UICollectionView.ScrollDirection) -> Bool {
        switch direction {
        case .horizontal:
            return contentSize.width <= bounds.width
        case .vertical:
            return contentSize.height <= bounds.height
        @unknown default:
            assertionFailure("Unhandled condition")
            return false
        }
    }
    
}
