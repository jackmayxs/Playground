//
//  BundlePlus.swift
//
//  Created by Choi on 2022/9/2.
//

import Foundation

extension Bundle {
    
    var displayName: String? {
        infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    /// 返回版本号
    var version: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// 返回build号
    var build: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
