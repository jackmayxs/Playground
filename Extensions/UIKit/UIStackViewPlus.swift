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
        self.init(axis: axis, distribution: distribution, alignment: alignment, spacing: spacing, arrangedSubviews: content())
	}
    
    convenience init(
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .leading,
        spacing: CGFloat = 0.0,
        arrangedSubviews: [UIView]
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
    
    func refill(@ArrayBuilder<UIView> _ arrangedSubviews: () -> [UIView]) {
        refill(arrangedSubviews())
    }
    
    func add(@ArrayBuilder<UIView> arrangedSubviews: () -> [UIView]) {
        add(arrangedSubviews: arrangedSubviews())
    }
    
    func refill<T>(_ arrangedSubviews: T...) where T: UIView {
        refill(arrangedSubviews)
    }
    
    func refill<T>(_ arrangedSubviews: T) where T: Sequence, T.Element: UIView {
        purgeArrangedSubviews()
        add(arrangedSubviews: arrangedSubviews)
    }
    
    func add<T>(arrangedSubviews: T) where T: Sequence, T.Element: UIView {
        arrangedSubviews.forEach { subview in
            addArrangedSubview(subview)
        }
    }
    
    /// Remove all of the arranged subviews
    func purgeArrangedSubviews() {
        arrangedSubviews.forEach { subview in
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
	
    var refilledArrangedSubviews: [UIView] {
        get { arrangedSubviews }
        set {
            refill(newValue)
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
