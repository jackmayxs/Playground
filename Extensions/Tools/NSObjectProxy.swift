//
//  NSObjectProxy.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/2/25.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

final class _NSObjectProxy: NSObject {
	
	private weak var target: NSObjectProtocol?
	
	init(target: NSObjectProtocol){
		self.target = target
		super.init()
	}
	
	//  核心代码
	override func forwardingTarget(for aSelector: Selector!) -> Any? {
		target
	}
	
	// NSObject 一些方法复写
	override func isEqual(_ object: Any?) -> Bool {
		target?.isEqual(object) ?? false
	}
	
	override var hash: Int {
		target?.hash ?? -1
	}
	
	override var superclass: AnyClass? {
		target?.superclass ?? nil
	}
	
//	override func `self`() -> Self{
//		return target?.self()
//	}
	
	override func isProxy() -> Bool {
		true
	}
	
	override func isKind(of aClass: AnyClass) -> Bool {
		target?.isKind(of: aClass) ?? false
	}
	
	override func isMember(of aClass: AnyClass) -> Bool {
		target?.isMember(of: aClass) ?? false
	}
	
	override func conforms(to aProtocol: Protocol) -> Bool {
		target?.conforms(to: aProtocol) ?? false
	}
	
	override func responds(to aSelector: Selector!) -> Bool {
		target?.responds(to: aSelector) ?? false
	}
	
	override var description: String {
		target?.description ?? "nil"
	}
	
	override var debugDescription: String {
		target?.debugDescription ?? "nil"
	}
}

extension NSObject {
	
	var proxy: _NSObjectProxy {
		_NSObjectProxy(target: self)
	}
}
