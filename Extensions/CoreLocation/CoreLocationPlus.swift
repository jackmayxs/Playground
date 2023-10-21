//
//  CoreLocation.swift
//  KnowLED
//
//  Created by Choi on 2023/10/21.
//

import Foundation
import CoreLocation

extension CLLocationManager {
    
    /// 位置权限
    var compatibleAuthorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            authorizationStatus
        } else {
            CLLocationManager.authorizationStatus()
        }
    }
}


extension CLAuthorizationStatus {
    
    var isAuthorized: Bool {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            true
        default:
            false
        }
    }
    
    var isNotDetermined: Bool {
        self == .notDetermined
    }
}
