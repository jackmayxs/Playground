//
//  BundlePlus.swift
//
//  Created by Choi on 2022/9/2.
//

import Foundation

extension Bundle {
    
    /// 显示名称
    var displayName: String? {
        infoDictionary.flatMap { $0["CFBundleDisplayName"] as? String }
    }
    
    /// 版本号(编译号)
    var versionWithBuild: String? {
        guard let version, let build else { return nil }
        return "\(version)(\(build))"
    }
    
    /// 返回版本号
    var version: String? {
        infoDictionary.flatMap { $0["CFBundleShortVersionString"] as? String }
    }
    
    /// 返回build号
    var build: String? {
        infoDictionary.flatMap { $0["CFBundleVersion"] as? String }
    }
}
