//
//  UIDevice+Rx.swift
//  KnowLED
//
//  Created by Choi on 2023/10/7.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base == UIDevice {
    
    /// 设备是否横屏 | 屏幕朝上/朝下的情况, 通过判断屏幕尺寸的宽高决定设备是否横屏
    /// 结合Size.screenSize方法, 可以映射出当前朝向的屏幕尺寸. e.g. isLandscape.map(Size.screenSize)
    static var isLandscape: Observable<Bool> {
        didChangeOrientation
            .map(\.isScreenLandscape)
            .distinctUntilChanged()
    }
    
    static var didChangeOrientation: Observable<UIDeviceOrientation> {
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
            .map(UIDevice.currentOrientation)
            .startWith(UIDevice.current.orientation)
            .do(onSubscribe: UIDevice.current.beginGeneratingDeviceOrientationNotifications)
            .do(onDispose: UIDevice.current.endGeneratingDeviceOrientationNotifications)
    }
}

extension UIDevice {
    fileprivate static func currentOrientation(_ notification: Notification) -> UIDeviceOrientation {
        guard let device = notification.object as? UIDevice else { return current.orientation }
        return device.orientation
    }
}
