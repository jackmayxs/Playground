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
	
    /// 添加StackView背景视图颜色
    /// - Parameter color: 背景View颜色
    func add(backgroundColor: UIColor) {
        let background = UIView(frame: bounds)
        background.backgroundColor = backgroundColor
        add(backgroundView: background)
    }
    
    func add(cornerRadius: CGFloat, insets: UIEdgeInsets = .zero, maskedCorners: CACornerMask = .allCorners, backgroundColor: UIColor) {
        let bgView = UIView(color: backgroundColor)
        bgView.layer.maskedCorners = maskedCorners
        bgView.layer.cornerRadius = cornerRadius
        add(backgroundView: bgView, insets: insets)
    }
    
    func stackOverlay(view: UIView) {
        add(backgroundView: view)
        bringSubviewToFront(view)
    }
    
    func add(backgroundView: UIView, insets: UIEdgeInsets = .zero, configure: ((UIView) -> Void)? = nil) {
        defer {
            configure?(backgroundView)
        }
        if let oldBaseView = baseView {
            oldBaseView.removeFromSuperview()
            baseView = nil
        }
        backgroundView.frame = bounds.inset(by: insets)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(backgroundView, at: 0)
        baseView = backgroundView
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
