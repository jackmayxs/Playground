//
//  UIApplicationPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/9/9.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

fileprivate typealias FirstResponderHandoff = (UIResponder) -> Void

extension UIApplication {
    
    struct Release {
        let version: String
        var notes: String?
        init?(version: String?, notes: String?) {
            guard let version else { return nil }
            self.version = version
            self.notes = notes
        }
        
        var needsUpdate: Bool {
            guard let appVersion = Bundle.main.version else { return false }
            return appVersion.compare(version, options: .numeric) == .orderedAscending
        }
    }
    
    static func getLatestRelease(completed: @escaping (Release?) -> Void) {
        
        func didGetNewRelease(_ release: Release?) {
            DispatchQueue.main.async {
                if release.isNotValid && isDebugging {
                    let release = Release(version: Bundle.main.version.orEmpty + ".1", notes: nil)
                    completed(release)
                    return
                }
                completed(release)
            }
        }
        let getAppVersion = DispatchWorkItem {
            guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(String.appID)") else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let response = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
                    didGetNewRelease(nil)
                    return
                }
                guard let results = response["results"] as? [[String: Any]], let info = results.first else {
                    didGetNewRelease(nil)
                    return
                }
                let version = info["version"] as? String
                let notes = info["releaseNotes"] as? String
                let release = Release(version: version, notes: notes)
                didGetNewRelease(release)
            } catch {
                completed(nil)
            }
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: getAppVersion)
    }
    
    static func openSettings() {
        guard let settingsURL = URL(string: openSettingsURLString) else { return }
        openURL(settingsURL)
    }
    
	/// UIApplication.openURL的封装方法
	/// - Parameters:
	///   - urlToOpen: 传入URL
	///   - options: 参数(带默认值)
	///   - completionHandler: 完成回调
	static func openURL(_ urlToOpen: URL,
						options: [OpenExternalURLOptionsKey : Any] = [:],
						completionHandler: ((Bool) -> Void)? = nil) {
		guard shared.canOpenURL(urlToOpen) else {
			assertionFailure("Can't open the given URL. Check and re-check.")
			return
		}
		if #available(iOS 10, *) {
			shared.open(urlToOpen, options: options, completionHandler: completionHandler)
		} else {
			shared.openURL(urlToOpen)
		}
	}
    
    /// 将第一响应者转换为UIView
    var firstResponderView: UIView? {
        firstResponder as? UIView
    }
    
    /// 获得应用当前的第一响应者
    var firstResponder: UIResponder? {
        
        /// 声明第一响应者临时变量
        var _firstResponder: UIResponder?
        
        /// 定义回传闭包
        let reportAsFirstHandler: FirstResponderHandoff = { responder in
            _firstResponder = responder
        }
        
        /// 将闭包通过这个方法发送出去
        sendAction(#selector(UIResponder.reportAsFirst), to: nil, from: reportAsFirstHandler, for: nil)
        
        /// 第一响应者被赋值之后返回
        return _firstResponder
    }
}

extension UIResponder {

    @objc fileprivate func reportAsFirst(_ sender: Any) {
        if let handoff = sender as? FirstResponderHandoff {
            /// 第一响应者回传
            handoff(self)
        }
    }

}
