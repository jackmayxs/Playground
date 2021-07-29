//
//  UIStackViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/10/10.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

typealias SubviewsBuilder = CommonBuilder<UIView>

extension UIStackView {
	
	convenience init(
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .leading,
		spacing: CGFloat = 0.0,
		@SubviewsBuilder content: () -> [UIView] = { [] }
	) {
		self.init(arrangedSubviews: content())
		self.axis = axis
		self.distribution = distribution
		self.alignment = alignment
		self.spacing = spacing
	}
	
	func addArrangedSubviews(@SubviewsBuilder content: () -> [UIView]) {
		content().forEach { subView in
			addArrangedSubview(subView)
		}
	}
	
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
