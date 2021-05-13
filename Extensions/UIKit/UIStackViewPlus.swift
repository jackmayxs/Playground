//
//  UIStackViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/10/10.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIStackView {
	
	/// Remove all of the arranged subviews
	func purgeArrangedSubviews() {
		arrangedSubviews.forEach { subview in
			removeArrangedSubview(subview)
			subview.removeFromSuperview()
		}
	}
	
    func addBackground(view: UIView) {
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(view, at: 0)
    }
    /// 添加StackView背景视图颜色
    /// - Parameter color: 背景View颜色
    func addBackground(color: UIColor) {
        let colored = UIView(frame: bounds)
        colored.backgroundColor = color
		addBackground(view: colored)
    }
}
