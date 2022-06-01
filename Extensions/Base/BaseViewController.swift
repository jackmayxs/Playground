//
//  BaseViewController.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/31.
//  Copyright © 2022 Choi. All rights reserved.
//

import UIKit

class BaseViewController<CoordinatorType: Coordinator>: UIViewController, Coordinating {
	
	/// 解除循环引用
	weak var coordinator: CoordinatorType?
	
	required convenience init(coordinator: CoordinatorType) {
		self.init(nibName: nil, bundle: nil)
		self.coordinator = coordinator
	}
}
