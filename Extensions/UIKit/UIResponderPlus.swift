//
//  UIResponderPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/8/26.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

fileprivate typealias FirstResponderHandoff = (UIResponder) -> Void

extension UIResponder {
    enum Associated {
        static var parentController = UUID()
    }
}

extension UIResponder {
    
    var associatedParentController: UIViewController? {
        associatedParentController(UIViewController.self)
    }
    
    /// 返回关联的控制器并储存起来
    /// - Parameter controllerType: 控制器类型
    /// - Returns: 关联的控制器
    func associatedParentController<Controller: UIViewController>(_ controllerType: Controller.Type) -> Controller? {
        if let controller = getAssociatedObject(self, &Associated.parentController) as? Controller {
            return controller
        }
        let fetchedController = parentController(controllerType)
        setAssociatedObject(self, &Associated.parentController, fetchedController, .OBJC_ASSOCIATION_ASSIGN)
        return fetchedController
    }
    
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
    
    /// 将第一响应者转换为UIView
    static var firstResponderView: UIView? {
        firstResponder as? UIView
    }
    
    /// 获得应用当前的第一响应者
    /// 参考链接: https://www.appcoda.com.tw/first-responder/
    static var firstResponder: UIResponder? {
        
        /// 声明第一响应者临时变量
        var _firstResponder: UIResponder?
        
        /// 定义回传闭包
        let reportAsFirstHandler: FirstResponderHandoff = { responder in
            _firstResponder = responder
        }
        
        /// 将闭包通过这个方法发送出去
        UIApplication.shared.sendAction(#selector(reportAsFirst), to: nil, from: reportAsFirstHandler, for: nil)
        
        /// 第一响应者被赋值之后返回
        return _firstResponder
    }
    
    @objc fileprivate func reportAsFirst(_ sender: Any) {
        if let handoff = sender as? FirstResponderHandoff {
            /// 第一响应者回传
            handoff(self)
        }
    }
}
