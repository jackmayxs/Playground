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
        insets: UIEdgeInsets = .zero,
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .leading,
		spacing: CGFloat = 0.0,
		@ArrayBuilder<UIView> arrangedSubviews: () -> [UIView] = { [] }
	) {
        self.init(insets: insets, axis: axis, distribution: distribution, alignment: alignment, spacing: spacing, arrangedSubviews: arrangedSubviews())
	}
    
    convenience init(
        insets: UIEdgeInsets = .zero,
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .leading,
        spacing: CGFloat = 0.0,
        arrangedSubviews: UIView...
    ) {
        self.init(insets: insets, axis: axis, distribution: distribution, alignment: alignment, spacing: spacing, arrangedSubviews: arrangedSubviews)
    }
    
    convenience init(
        insets: UIEdgeInsets = .zero,
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .leading,
        spacing: CGFloat = 0.0,
        arrangedSubviews: [UIView]
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.contentInsets = insets
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        for subview in arrangedSubviews {
            if let afterSpacing = subview.afterSpacing {
                setCustomSpacing(afterSpacing, after: subview)
            }
        }
    }
    
    func reArrange(@ArrayBuilder<UIView> _ arrangedSubviews: () -> [UIView]) {
        reArrange(arrangedSubviews())
    }
    
    func arrange(@ArrayBuilder<UIView> arrangedSubviews: () -> [UIView]) {
        arrange(arrangedSubviews: arrangedSubviews())
    }
    
    func reArrange<T>(_ arrangedSubviews: T...) where T: UIView {
        reArrange(arrangedSubviews)
    }
    
    func reArrange<T>(_ arrangedSubviews: T) where T: Sequence, T.Element: UIView {
        purgeArrangedSubviews()
        arrange(arrangedSubviews: arrangedSubviews)
    }
    
    func arrange<T>(arrangedSubviews: T) where T: Sequence, T.Element: UIView {
        arrangedSubviews.forEach { subview in
            addArrangedSubview(subview)
            /// Tip: 如果后面还有别的arrangedSubview的时候，customSpacing才有效
            /// 如果后面没有别的arrangedSubview则最后一个子视图后面使用contentInsets作为内边距
            if let afterSpacing = subview.afterSpacing {
                setCustomSpacing(afterSpacing, after: subview)
            }
        }
    }
    
    /// Remove all of the arranged subviews
    func purgeArrangedSubviews() {
        arrangedSubviews.forEach(purgeArrangedSubview)
    }
    
    /// 清除指定的arrangedSubview
    /// - Parameter view: 指定的arrangedSubview
    func purgeArrangedSubview(_ view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
	
    var reArrangedSubviews: [UIView] {
        get { arrangedSubviews }
        set {
            reArrange(newValue)
        }
    }
    
	/// 内部控件边距
	var contentInsets: UIEdgeInsets? {
		get {
			if #available(iOS 11, *) {
				return directionalLayoutMargins.uiEdgeInsets
			} else {
                return layoutMargins
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
