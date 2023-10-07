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
    
    static var isLandscape: Observable<Bool> {
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
            .map { _ in
                UIDevice.current.orientation
            }
            .startWith(UIDevice.current.orientation)
            .compactMap { orientation -> Bool? in
                switch orientation {
                case .unknown:
                    return nil
                case .portrait:
                    return false
                case .portraitUpsideDown:
                    return false
                case .landscapeLeft:
                    return true
                case .landscapeRight:
                    return true
                case .faceUp:
                    return nil
                case .faceDown:
                    return nil
                @unknown default:
                    return nil
                }
            }
            .distinctUntilChanged()
    }
}
