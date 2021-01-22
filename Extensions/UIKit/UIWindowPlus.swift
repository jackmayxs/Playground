//
//  UIWindowPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/23.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UIWindow {
	
	static var keyWindow: UIWindow? {
		
		if #available(iOS 13.0, *) {
			var windowScene: UIWindowScene? {
				UIApplication.shared.connectedScenes.randomElement() as? UIWindowScene
			}
			return windowScene?.windows.first
		} else {
			return UIApplication.shared.keyWindow
		}
	}
}
