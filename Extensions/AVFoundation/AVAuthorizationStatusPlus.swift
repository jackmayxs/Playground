//
//  AVAuthorizationStatusPlus.swift
//  zeniko
//
//  Created by Choi on 2022/9/30.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension AVAuthorizationStatus {
    
    // 检查相机权限
    static var checkCameraStatus: Infallible<AVAuthorizationStatus> {
        statusFor(.video).take(1).asInfallible(onErrorJustReturn: .denied)
    }
    
    static func statusFor(_ mediaType: AVMediaType) -> Observable<AVAuthorizationStatus> {
        Observable.create { observer in
            let currentStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
            switch currentStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { authorized in
                    /// 注意:这里是非主线程
                    observer.on(authorized ? .next(.authorized) : .next(.denied))
                    observer.onCompleted()
                }
            default:
                observer.onNext(currentStatus)
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
    }
}
