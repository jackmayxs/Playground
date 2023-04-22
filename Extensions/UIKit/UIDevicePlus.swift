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
    
    /// 获取设备名. e.g. iPhone13,4
    static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
