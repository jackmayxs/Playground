//
//  Coordinator.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/30.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
	var childCoordinators: [any Coordinator] { get set }
	var navigationController: UINavigationController { get set }
	
	func start()
}

class MainCoordinator: NSObject, Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		navigationController.delegate = self
		let vc = ViewController.instantiate
		vc.tabBarItem = .init(tabBarSystemItem: .favorites, tag: 0)
		vc.coordinator = self
		navigationController.pushViewController(vc, animated: false)
	}
	
	func buySubscription(to passedData: Int) {
		let child = BuyCoordinator(navigationController: navigationController)
		child.parentCoordinator = self
		childCoordinators.append(child)
		child.start()
	}
	
	func childDidFinish(_ child: Coordinator?) {
		for (index, coordinator) in childCoordinators.enumerated() {
			if coordinator === child {
				childCoordinators.remove(at: index)
				break
			}
		}
	}
}

extension MainCoordinator: UINavigationControllerDelegate {
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
			childDidFinish(buyViewController.coordinator)
		}
	}
}
