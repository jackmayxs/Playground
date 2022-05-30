//
//  NSObjectPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/7/29.
//  Copyright © 2020 Choi. All rights reserved.
//

import Foundation

extension NSObject {
	
	/// 转换成指针
	public var rawPointer: UnsafeMutableRawPointer {
		Unmanaged.passUnretained(self).toOpaque()
	}
	
	var proxy: _NSObjectProxy<NSObject> {
		_NSObjectProxy(target: self)
	}
	
	func proxy<T>(_ target: T) -> _NSObjectProxy<T> where T: NSObjectProtocol {
		_NSObjectProxy(target: target)
	}
}

final class _NSObjectProxy<T: NSObjectProtocol>: NSObject {
	
	private(set) weak var _target: T!
	var target: T {
		_target
	}
	
	init(target: T){
		_target = target
		super.init()
	}
	
	//  核心代码
	override func forwardingTarget(for aSelector: Selector!) -> Any? {
		_target
	}
	
	// NSObject 一些方法复写
	override func isEqual(_ object: Any?) -> Bool {
		_target.isEqual(object)
	}
	
	override var hash: Int {
		_target.hash
	}
	
	override var superclass: AnyClass? {
		_target.superclass ?? nil
	}
	
	func `self`() -> T {
		_target.self
	}
	
	override func isProxy() -> Bool {
		true
	}
	
	override func isKind(of aClass: AnyClass) -> Bool {
		_target.isKind(of: aClass)
	}
	
	override func isMember(of aClass: AnyClass) -> Bool {
		_target.isMember(of: aClass)
	}
	
	override func conforms(to aProtocol: Protocol) -> Bool {
		_target.conforms(to: aProtocol)
	}
	
	override func responds(to aSelector: Selector!) -> Bool {
		_target.responds(to: aSelector)
	}
	
	override var description: String {
		_target.description
	}
	
	override var debugDescription: String {
		_target.debugDescription
	}
}
