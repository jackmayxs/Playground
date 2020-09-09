//
//  UIApplicationPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/9/9.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIApplication {
	
	/// UIApplication.openURL的封装方法
	/// - Parameters:
	///   - urlToOpen: 传入URL
	///   - options: 参数(带默认值)
	///   - completionHandler: 完成回调
	static func openURL(_ urlToOpen: URL,
						options: [OpenExternalURLOptionsKey : Any] = [:],
						completionHandler: ((Bool) -> Void)? = nil) {
		guard shared.canOpenURL(urlToOpen) else {
			assertionFailure("Can't open the given URL. Check and re-check.")
			return
		}
		if #available(iOS 10, *) {
			shared.open(urlToOpen, options: options, completionHandler: completionHandler)
		} else {
			shared.openURL(urlToOpen)
		}
	}
}
