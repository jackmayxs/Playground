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

extension AVAuthorizationStatus: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .notDetermined:
            return "NOT DETERMINED."
        case .restricted:
            return "RESTRICTED"
        case .denied:
            return localized.相机未授权~
        case .authorized:
            return "AUTHORIZED"
        @unknown default:
            return "UNKNOWN STATUS"
        }
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        switch self {
        case .notDetermined:
            return "NOT DETERMINED."
        case .restricted:
            return "RESTRICTED"
        case .denied:
            return "DENIED"
        case .authorized:
            return "AUTHORIZED"
        @unknown default:
            return "UNKNOWN STATUS"
        }
    }

    /// A localized message describing how one might recover from the failure.
    public var recoverySuggestion: String? {
        switch self {
        case .notDetermined:
            return "NOT DETERMINED."
        case .restricted:
            return "RESTRICTED"
        case .denied:
            return "DENIED"
        case .authorized:
            return "AUTHORIZED"
        @unknown default:
            return "UNKNOWN STATUS"
        }
    }

    /// A localized message providing "help" text if the user requests help.
    public var helpAnchor: String? {
        switch self {
        case .notDetermined:
            return "NOT DETERMINED."
        case .restricted:
            return "RESTRICTED"
        case .denied:
            return "DENIED"
        case .authorized:
            return "AUTHORIZED"
        @unknown default:
            return "UNKNOWN STATUS"
        }
    }
}

extension AVAuthorizationStatus {
    
    /// 返回可以拍照的权限 | 否则抛出错误
    var validStatus: AVAuthorizationStatus {
        get throws {
            switch self {
            case .notDetermined, .authorized:
                return self
            case .restricted, .denied:
                throw self
            @unknown default:
                fatalError("NEW STATUS NOT HANDLED.")
            }
        }
    }
}

extension AVAuthorizationStatus {
    
    static var checkValidCameraStatus: Observable<AVAuthorizationStatus> {
        checkCameraStatus.observable.map { status in
            try status.validStatus
        }
    }
    
    // 检查相机权限
    static var checkCameraStatus: Infallible<AVAuthorizationStatus> {
        statusFor(.video).asInfallible(onErrorJustReturn: .denied)
    }
    
    static func statusFor(_ mediaType: AVMediaType) -> Single<AVAuthorizationStatus> {
        Single.create { observer in
            let currentStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
            switch currentStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { authorized in
                    /// 注意:这里是非主线程
                    observer(.success(authorized ? .authorized : .denied))
                }
            default:
                observer(.success(currentStatus))
            }
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
    }
}
