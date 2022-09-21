//
//  UIStackViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/10/10.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIStackView {

	convenience init(
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .leading,
		spacing: CGFloat = 0.0,
		@ArrayBuilder<UIView> content: () -> [UIView] = { [] }
	) {
		self.init(arrangedSubviews: content())
		self.axis = axis
		self.distribution = distribution
		self.alignment = alignment
		self.spacing = spacing
	}
	
	func addArrangedSubviews(@ArrayBuilder<UIView> content: () -> [UIView]) {
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
    
    func refill(@ArrayBuilder<UIView> content: () -> [UIView]) {
        purgeArrangedSubviews()
        addArrangedSubviews(content: content)
    }
	
	/// 内部控件边距
	var contentInsets: UIEdgeInsets? {
		get {
			if #available(iOS 11, *) {
				return directionalLayoutMargins.uiEdgeInsets
			} else {
				return isLayoutMarginsRelativeArrangement ? layoutMargins : .none
			}
		}
		set {
			guard let insets = newValue else {
				isLayoutMarginsRelativeArrangement = false
				return
			}
			isLayoutMarginsRelativeArrangement = true
			if #available(iOS 11, *) {
				directionalLayoutMargins = insets.directionalEdgeInsets
			} else {
				layoutMargins = insets
			}
		}
	}
	var horizontalInsets: UIEdgeInsets? {
		get { contentInsets }
		set {
			guard var insets = newValue else { return }
			insets.top = 0
			insets.bottom = 0
			contentInsets = insets
		}
	}
	var verticalInsets: UIEdgeInsets? {
		get { contentInsets }
		set {
			guard var insets = newValue else { return }
			insets.left = 0
			insets.right = 0
			contentInsets = insets
		}
	}
}
