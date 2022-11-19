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
            return UIApplication.shared
                .connectedScenes
                .as(UIWindowScene.self)
                .flatMap(\.windows)
                .first(where: \.isKeyWindow)
		} else {
			return UIApplication.shared.keyWindow
		}
	}
}
