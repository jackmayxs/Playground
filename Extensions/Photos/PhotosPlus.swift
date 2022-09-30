//
//  PhotosPlus.swift
//  zeniko
//
//  Created by Choi on 2022/8/16.
//

import Photos
import PhotosUI
import RxSwift
import RxCocoa

extension PHPhotoLibrary {
    
    /// 检查或请求相册权限
    static var chekAuthorizationStatus: Observable<PHAuthorizationStatus> {
        Single.create { observer in
            let status = PHPhotoLibrary.authorizationStatus
            switch status {
            case .notDetermined:
                /// 请求权限
                PHPhotoLibrary.compatibleRequestAuthorization { updatedStatus in
                    observer(.success(updatedStatus))
                }
            default:
                observer(.success(status))
            }
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
        .asObservable()
    }
    
    /// 当前相册权限
    static var authorizationStatus: PHAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return authorizationStatus(for: .readWrite)
        } else {
            return authorizationStatus()
        }
    }
    
    /// 请求相册权限
    /// - Parameter handler: 处理回调
    static func compatibleRequestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        if #available(iOS 14.0, *) {
            requestAuthorization(for: .readWrite, handler: handler)
        } else {
            requestAuthorization(handler)
        }
    }
}
