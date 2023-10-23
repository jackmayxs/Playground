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
    
    /// 返回Wi-Fi的SSID或局域网连接类型
    /// 需要用户开启定位权限才能获取到SSID
    var lanConnectionName: Observable<String?> {
        LocationManager.rx.authorizationStatus.map { status -> String? in
            guard let interface = base.availableInterfaces.first else { return nil }
            guard let networkInfo = CNCopyCurrentNetworkInfo(interface.name.cfString) else {
                if let supportedInterfaces = CNCopySupportedInterfaces() {
                    if let en0 = (supportedInterfaces as NSArray).firstObject as? String {
                        if interface.name == en0 {
                            /// 无定位权限的情况
                            return "WLAN"
                        }
                    }
                }
                return "LAN"
            }
            let SSID = (networkInfo as NSDictionary)[kCNNetworkInfoKeySSID as String] as? String
            return SSID
        }
    }
}
