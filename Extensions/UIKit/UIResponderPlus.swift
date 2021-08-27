//
//  UIResponderPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/8/26.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UIResponder {
	
	/// 获取Parent控制器
	/// - Parameter type: 控制器类型
	/// - Returns: 匹配的控制器
	func parentController<Controller: UIViewController>(_ type: Controller.Type) -> Controller? {
		var nextResponder = next
		while let controller = nextResponder {
			if let valid = controller as? Controller {
				return valid
			}
			nextResponder = controller.next
		}
		return nextResponder as? Controller
	}
	
	func parentView<View: UIView>(_ type: View.Type) -> View? {
		var nextResponder = next
		while let superView = nextResponder {
			if let valid = superView as? View {
				return valid
			}
			nextResponder = superView.next
		}
		return nextResponder as? View
	}
}
