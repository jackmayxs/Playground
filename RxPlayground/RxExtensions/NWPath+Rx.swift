//
//  NWPath+Rx.swift
//  KnowLED
//
//  Created by Choi on 2023/10/21.
//

import Foundation
import Network
import SystemConfiguration.CaptiveNetwork
import RxSwift
import RxCocoa

extension NWPath: ReactiveCompatible {}

extension Reactive where Base == NWPath {
    
    /// 如果为nil, 则为有线连接
    var maybeSSID: Observable<String?> {
        LocationManager.rx.authorizationStatus.map { status -> String? in
            guard let interface = base.availableInterfaces.first else { return nil }
            guard let networkInfo = CNCopyCurrentNetworkInfo(interface.name.cfString) else {
                if let supportedInterfaces = CNCopySupportedInterfaces() {
                    if let en0 = (supportedInterfaces as NSArray).firstObject as? String {
                        if interface.name == en0 {
                            return "WLAN"
                        }
                    }
                }
                return nil
            }
            let SSID = (networkInfo as NSDictionary)[kCNNetworkInfoKeySSID as String] as? String
            return SSID
        }
    }
}
