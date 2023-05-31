//
//  UINavigationControllerPlus.swift
//
//  Created by Choi on 2022/9/1.
//

import UIKit

extension UINavigationController {
    
    convenience init(@ArrayBuilder<UIViewController> _ controllersBuilder: () -> [UIViewController]) {
        var controllers = controllersBuilder()
        guard controllers.isNotEmpty else {
            self.init()
            return
        }
        let rootController = controllers.removeFirst()
        self.init(rootViewController: rootController)
        controllers.forEach { controller in
            pushViewController(controller, animated: false)
        }
    }
    
    /// 新控制器压栈 | 移除所有以前的控制器
    /// - Parameters:
    ///   - newRootController: 新的根控制器
    func refillNavigationStack(_ newRootController: UIViewController, animated: Bool = true) {
        let previousControllersCount = viewControllers.count
        pushViewController(newRootController, animated: animated)
        viewControllers.removeFirst(previousControllersCount)
    }
    
    /// 替换顶层控制器
    /// - Parameters:
    ///   - newController: 顶层控制器
    func replaceTopViewController(_ newController: UIViewController, animated: Bool = true) {
        let lastTopControllerIndex = viewControllers.count - 1
        pushViewController(newController, animated: animated)
        viewControllers.remove(at: lastTopControllerIndex)
    }
}
