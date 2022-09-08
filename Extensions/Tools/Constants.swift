//
//  Constants.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/20.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

enum Size {
	
	static let commonSafeAreaInsets = UIWindow.keyWindow?.safeAreaInsets ?? .zero
	
	static let screenScale = UIScreen.main.scale
	
	static let screenHeight = UIScreen.main.bounds.height
	
	static let screenWidth = UIScreen.main.bounds.width
	
	static let screenSize = UIScreen.main.bounds.size
}
