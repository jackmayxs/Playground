//
//  DispatchOnce.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/7/29.
//  Copyright © 2020 Choi. All rights reserved.
//

import Foundation

struct Dispatch {
	
	private static var tokens = Set<String>()
	
	public static func once(file: String = #file,
							function: String = #function,
							line: Int = #line,
							execute: () -> Void) {
		let token = "\(file):\(function):\(line)"
		once(token: token, execute: execute)
	}
	
	public static func once(token: String, execute: () -> Void) {
		guard !tokens.contains(token) else { return }
		objc_sync_enter(self)
		defer {
			objc_sync_exit(self)
		}
		tokens.insert(token)
		execute()
	}
    
    public static func once(userDefaultKey: String, execute: () -> Void) {
        if UserDefaults.standard.value(forKey: userDefaultKey).isValid {
            return
        }
        UserDefaults.standard.setValue(String.randomUUID, forKey: userDefaultKey)
        once(token: userDefaultKey, execute: execute)
    }
}
