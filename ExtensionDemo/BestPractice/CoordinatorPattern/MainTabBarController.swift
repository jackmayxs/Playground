//
//  MainTabBarController.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/30.
//  Copyright © 2022 Choi. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {
	let mainNavigationController = UINavigationController()
	lazy var mainCoordinator = MainCoordinator(navigationController: mainNavigationController)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mainCoordinator.start()
		viewControllers = [
			mainCoordinator.navigationController
		]
	}
}
