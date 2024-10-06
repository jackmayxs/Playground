//
//  UITabBarItemPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/28.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UITabBarItem {
	
    enum Associated {
        @UniqueAddress static var badgeView
    }
	
	private var container: UIView? {
		value(forKey: "_view") as? UIView // UITabbarButton
	}
	
	private var imageView: UIView? {
		guard let container = container else { return nil }
		guard let className = NSClassFromString("UITabBarSwappableImageView") else { return nil }
		for subView in container.subviews {
			if subView.isMember(of: className) {
				return subView
			}
		}
		return nil
	}
	
	private var badgeView: UIView? {
        guard let badge = associated(UIView.self, self, Associated.badgeView) else {
			guard let imageView = imageView else { return nil }
			let badgeSize: CGFloat = 10
			let x = imageView.frame.origin.x + imageView.bounds.size.width + 1
			let y = imageView.frame.origin.y - badgeSize/2
			let badgeFrame = CGRect(x: x, y: y, width: badgeSize, height: badgeSize)
			let badge = UIView(frame: badgeFrame)
			badge.backgroundColor = .systemRed
			container?.addSubview(badge)
			
            setAssociatedObject(self, Associated.badgeView, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return badge
		}
		return badge
	}
	
	private var hasBadge: Bool {
		badgeValue == .none
	}
	
	var showBadge: Bool {
		get { badgeView?.isHidden ?? true }
		set { badgeView?.isHidden = newValue }
	}
}
