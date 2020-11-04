//
//  UIEdgeInsetsPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/11/4.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
	var reverse: UIEdgeInsets {
		UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
	}
}

extension UIEdgeInsets: ExtendableBySize {
	var vertical: CGFloat { left + right }
	var horizontal: CGFloat { top + bottom }
}
