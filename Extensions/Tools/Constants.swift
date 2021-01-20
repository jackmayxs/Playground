//
//  Constants.swift
//  ExtensionDemo
//
//  Created by Major on 2021/1/20.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

enum Size {
	
	var commonSafeAreaInsets: UIEdgeInsets {
		if #available(iOS 13.0, *) {
			return UIApplication.shared.windows.filter(\.isKeyWindow).first?.safeAreaInsets ?? .zero
		}
		else if #available(iOS 11.0, *) {
			return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
		}
		return .zero
	}
}
