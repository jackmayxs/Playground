//
//  UIDevicePlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/24.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit
import AVFoundation

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

extension UIDeviceOrientation {
    
    /// 是否属于正常的四种朝向
    var isRegularOrientation: Bool {
        switch self {
        case .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight:
            true
        default:
            false
        }
    }
    
    /// 修正为:正常的四种朝向
    var regularOrientation: UIDeviceOrientation {
        /// 默认朝向 | 前置摄像头朝左,Home按钮朝右
        lazy var defaultRegularOrientation = UIDeviceOrientation.landscapeLeft
        if isRegularOrientation {
            return self
        } else {
            if #available(iOS 13.0, *) {
                if let window = UIApplication.shared.windows.first {
                    if let windowScene = window.windowScene {
                        return windowScene.interfaceOrientation.regularDeviceOrientation
                    } else {
                        return defaultRegularOrientation
                    }
                } else {
                    return defaultRegularOrientation
                }
            } else {
                return UIApplication.shared.statusBarOrientation.regularDeviceOrientation
            }
        }
    }
    
    var captureVideoOrientation: AVCaptureVideoOrientation {
        switch regularOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        default:
            fatalError("Should not happen.")
        }
    }
    
    /// 判断屏幕是否是竖屏
    var isScreenPortrait: Bool {
        !isScreenLandscape
    }
    
    /// 判断屏幕是否横屏 | 因为上游传入的状态不可靠, 所以不使用UIDeviceOrientation.isLandscape属性判断是否横屏
    var isScreenLandscape: Bool {
        lazy var isLandscape = UIScreen.main.bounds.size.isLandscape
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.windows.first {
                if let windowScene = window.windowScene {
                    return windowScene.interfaceOrientation.isScreenLandscape
                } else {
                    return isLandscape
                }
            } else {
                return isLandscape
            }
        } else {
            return UIApplication.shared.statusBarOrientation.isScreenLandscape
        }
    }
}

extension UIInterfaceOrientation {
    
    /// 判断屏幕是否横屏 | unknown情况下使用屏幕尺寸判断是否横屏
    var isScreenLandscape: Bool {
        switch self {
        case .unknown:
            return UIScreen.main.bounds.size.isLandscape
        default:
            return isLandscape
        }
    }
    
    /// 转换成常见的四种设备朝向之一
    /// 只包含: .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight 四种可能
    var regularDeviceOrientation: UIDeviceOrientation {
        /// 默认朝向 | 前置摄像头朝左,Home按钮朝右
        lazy var defaultRegularOrientation = UIDeviceOrientation.landscapeLeft
        switch self {
        case .unknown:
            dprint("未知朝向")
            return defaultRegularOrientation
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft: /// Home按钮在左
            return .landscapeRight /// 前置摄像头在右
        case .landscapeRight: /// Home按钮在右
            return .landscapeLeft /// 前置摄像头在左
        @unknown default:
            assertionFailure("Unhandled condition")
            return defaultRegularOrientation
        }
    }
}
