//
//  PhotosPlus.swift
//  zeniko
//
//  Created by Choi on 2022/8/16.
//

import Photos
import PhotosUI

extension PHPhotoLibrary {
    static var authorizationStatus: PHAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return authorizationStatus(for: .readWrite)
        } else {
            return authorizationStatus()
        }
    }
    static func compatibleRequestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        if #available(iOS 14.0, *) {
            requestAuthorization(for: .readWrite, handler: handler)
        } else {
            requestAuthorization(handler)
        }
    }
}
