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
		arrangedSubviews.forEach { sub in
			removeArrangedSubview(sub)
			sub.removeFromSuperview()
		}
	}
	
    func addBackgroundView(_ backgroundView: UIView) {
        backgroundView.frame = bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(backgroundView, at: 0)
    }
    /// 添加StackView背景视图颜色
    /// - Parameter color: 背景View颜色
    func addBackground(_ color: UIColor) {
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = color
        addBackgroundView(backgroundView)
    }
}
