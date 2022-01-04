//
//  UIStackViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/10/10.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIStackView {
	enum Associated {
		static var backgroundView = UUID()
	}
	var backgroundView: UIView? {
		get { objc_getAssociatedObject(self, &Associated.backgroundView) as? UIView }
		set {
			backgroundView?.removeFromSuperview()
			objc_setAssociatedObject(self, &Associated.backgroundView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
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
		backgroundView = view
    }
    /// 添加StackView背景视图颜色
    /// - Parameter color: 背景View颜色
    func addBackground(color: UIColor) {
        let colored = UIView(frame: bounds)
        colored.backgroundColor = color
		addBackground(view: colored)
		backgroundView = colored
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
