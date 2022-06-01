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
	var parentCoordinator: Coordinator? { get set }
	var childCoordinators: [any Coordinator] { get set }
	var navigationController: UINavigationController { get set }
	init(navigationController: UINavigationController)
	
	func start()
	func childFinished(_ child: Coordinator?)
}

extension Coordinator {
	func start() {}
	func childFinished(_ child: Coordinator?) {
		guard let validChild = child else { return }
		for (index, element) in childCoordinators.lazy.reversed().enumerated() {
			if element === validChild {
				childCoordinators.remove(at: index)
				break
			}
		}
	}
}

/// Usually conformed by a view controller.
protocol Coordinating: AnyObject {
	associatedtype CoordinatorType: Coordinator
	var coordinator: CoordinatorType? { get set }
	init(coordinator: CoordinatorType)
}

/// Inherit from NSObject to conform to the UINavigationControllerDelegate
class BaseCoordinator: NSObject, Coordinator {
	weak var parentCoordinator: Coordinator?
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController
	required init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	convenience init(parent: Coordinator) {
		self.init(navigationController: parent.navigationController)
		self.parentCoordinator = parent
		/// 注意这里对子Coordinator的引用
		/// 因为BuyCoordinator直到start被调用时才会对自己引用
		/// 子Coordinator被MainCoordinator的数组引用,以避免调用star()的时候内存地址无效的问题
		parent.childCoordinators.append(self)
	}
	deinit {
		/// 当自己快被销毁的时候,把自己从parent中移除
		parentCoordinator?.childFinished(self)
	}
}
