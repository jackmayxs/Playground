//
//  UIEdgeInsetsPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/11/4.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
	var reversed: UIEdgeInsets {
		UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
	}
}

extension UIEdgeInsets: SizeExtendable {
	var vertical: CGFloat { top + bottom }
	var horizontal: CGFloat { left + right }
}
