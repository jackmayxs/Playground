//
//  UIViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/14.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

// MARK: - __________ Array<UIView> __________
extension Array where Element: UIView {
	
	/// 将UIView的数组包装的StackView里
	/// - Returns: The stack view wrapping the given view array as arranged subviews.
	func embedInStackView(
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .leading,
		spacing: CGFloat = 0) -> UIStackView
	{
		let stackView = UIStackView(arrangedSubviews: self)
		stackView.axis = axis
		stackView.distribution = distribution
		stackView.alignment = alignment
		stackView.spacing = spacing
		return stackView
	}
}
