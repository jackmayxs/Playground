//
//  LocationManager.swift
//  KnowLED
//
//  Created by Choi on 2023/10/21.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class LocationManager: NSObject {
    /// 单例对象
    static let shared = LocationManager()
    /// 定位管理器核心对象
    let core = CLLocationManager()
    /// 定位权限
    @Variable var authorizationStatus: CLAuthorizationStatus?
    
    private override init() {
        super.init()
        /// 设置代理
        core.delegate = self
    }
}

extension LocationManager {
    
    /// 请求位置权限
    static func requestAuthorizationIfNeeded() {
        guard let infoDictionary = Bundle.main.infoDictionary else { return }
        lazy var infoKeys = infoDictionary.keys
        let core = LocationManager.shared.core
        if core.compatibleAuthorizationStatus.isNotDetermined {
            if infoKeys.contains(.whenInUseUsageDescription) {
                core.requestWhenInUseAuthorization()
            } else if infoKeys.contains(.alwaysAndWhenInUseUsageDescription) || infoKeys.contains(.alwaysUsageDescription) {
                core.requestAlwaysAuthorization()
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            authorizationStatus = manager.authorizationStatus
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if #unavailable(iOS 14.0) {
            authorizationStatus = status
        }
    }
}

extension Reactive where Base == LocationManager {
    
    static var authorizationStatus: Observable<CLAuthorizationStatus> {
        LocationManager.shared.$authorizationStatus
            .unwrapped
            .do(onSubscribe: LocationManager.requestAuthorizationIfNeeded)
    }
}

fileprivate extension String {
    static let alwaysAndWhenInUseUsageDescription = "NSLocationAlwaysAndWhenInUseUsageDescription"
    static let alwaysUsageDescription = "NSLocationAlwaysUsageDescription"
    static let whenInUseUsageDescription = "NSLocationWhenInUseUsageDescription"
    static let usageDescription = "NSLocationUsageDescription"
    static let temporaryUsageDescriptionDictionary = "NSLocationTemporaryUsageDescriptionDictionary"
}
