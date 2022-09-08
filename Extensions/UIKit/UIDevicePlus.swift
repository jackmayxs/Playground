//
//  UIDevicePlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/24.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UIDevice {
	
	/// 相机是否可用
	///
	/// - Returns: 可用则返回 true,否则 false
	static var isCameraAvailable: Bool {
		UIImagePickerController.isSourceTypeAvailable(.camera)
	}
	
	/// 前置摄像头是否可用
	///
	/// - Returns: 可用则返回 true,否则 false
	static var isFrontCameraAvailable: Bool {
		UIImagePickerController.isCameraDeviceAvailable(.front)
	}
	
	/// 后置摄像头是否可用
	///
	/// - Returns: 可用则返回 true,否则 false
	static var isRearCameraAvailable: Bool {
		UIImagePickerController.isCameraDeviceAvailable(.rear)
	}
}
