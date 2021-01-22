//
//  Constants.swift
//  ExtensionDemo
//
//  Created by Major on 2021/1/20.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

enum Size {
	
	static var commonSafeAreaInsets: UIEdgeInsets {
		UIWindow.keyWindow?.safeAreaInsets ?? .zero
	}
}
