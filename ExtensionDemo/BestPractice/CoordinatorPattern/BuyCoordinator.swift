//
//  BuyCoordinator.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/30.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation
import UIKit

class BuyCoordinator: Coordinator {
	weak var parentCoordinator: MainCoordinator?
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = BuyViewController.instantiate
		vc.coordinator = self
		navigationController.pushViewController(vc, animated: true)
	}
}
