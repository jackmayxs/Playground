//
//  UIViewControllerPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/3/3.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UINavigationController {
    
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

extension UIViewController {
    
    func push(_ controller: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    
    func embedInNavigationController<NavigationController>(_ navigationControllerType: NavigationController.Type = UINavigationController.self as! NavigationController.Type) -> NavigationController where NavigationController: UINavigationController {
        NavigationController(rootViewController: self)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
	
	private struct Preview: UIViewControllerRepresentable {
		
		let viewController: UIViewController

		func makeUIViewController(context: Context) -> UIViewController { viewController }

		func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
	}

	var preview: some View {
		Preview(viewController: self)
	}
}
#endif
