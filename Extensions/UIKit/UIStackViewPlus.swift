//
//  UIStackViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/10/10.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIStackView {
	
	/// 添加StackView背景视图颜色
	/// - Parameter color: 背景View颜色
	func addBackground(_ color: UIColor) {
		let subView = UIView(frame: bounds)
		subView.backgroundColor = color
		subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		insertSubview(subView, at: 0)
	}
}
