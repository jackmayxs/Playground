//
//  MainCoordinator.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/31.
//  Copyright © 2022 Choi. All rights reserved.
//

import UIKit

final class MainCoordinator: BaseCoordinator {
	
	func start() {
//		let vc = ViewController.instantiate
//		vc.tabBarItem = .init(tabBarSystemItem: .favorites, tag: 0)
//		vc.coordinator = self
//		navigationController.pushViewController(vc, animated: false)
	}
	
	func buySubscription(to passedData: Int) {
		let child = BuyCoordinator(parent: self)
		child.start()
	}
}

extension MainCoordinator: UINavigationControllerDelegate {
	
	/// 导航控制器代理方法
	/// - Parameters:
	///   - navigationController: 导航控制器
	///   - viewController: 目标控制器
	///   - animated: 是否动画展示
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
			return
		}
		/// 压栈
		if navigationController.viewControllers.contains(fromViewController) {
			return
		}
		/// 出栈 | 处理MainCoordinator的子Coordinator
		if let buyViewController = fromViewController as? BuyViewController {
//			childFinished(buyViewController.coordinator)
		}
	}
}
