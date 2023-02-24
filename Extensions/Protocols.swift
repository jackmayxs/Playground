//
//  Protocols.swift
//
//  Created by Choi on 2020/9/6.
//  Copyright © 2020年 All rights reserved.
//

import UIKit

protocol StandardLayoutLifeCycle: UIView {
    
    func prepare()
    
    func prepareSubviews()
    
    func prepareConstraints()
}

extension StandardLayoutLifeCycle {
    
    func prepare() {
        prepareSubviews()
        prepareConstraints()
    }
}

protocol ConditionCheckable {
	func matchOrNil(condition: (Self) -> Bool) -> Self?
}
extension ConditionCheckable {
	func matchOrNil(condition: (Self) -> Bool) -> Self? {
		if condition(self) {
			return self
		} else {
			return nil
		}
	}
	func matchCaseOrNil(case: Self) -> Self? where Self: Comparable {
		if self == `case` {
			return self
		} else {
			return nil
		}
	}
}
extension String: ConditionCheckable { }

@dynamicMemberLookup
struct Configurator<Object> {
	var stabilized: Object { target }
	private let target: Object
	init(_ target: Object) {
		self.target = target
	}
	subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Object, Value>)
	-> ( (Value) -> Configurator<Object> ) {
		{ value in
			target[keyPath: keyPath] = value
			return self
		}
	}
	func stabilize(_ configure: (Object) -> Void) -> Object {
		configure(target)
		return self.stabilized
	}
}

protocol Chainable {}
extension Chainable {
	var set: Configurator<Self> {
		Configurator(self)
	}
}
extension Chainable where Self: SimpleInitializer {
	static var make: Configurator<Self> {
		self.init().set
	}
}
extension NSObject: Chainable { }

// MARK: - __________ Storyboarded __________
protocol Storyboarded {
	static var bundle: Bundle { get }
	static var storyboardName: String { get }
	static var instantiate: Self { get }
}
extension Storyboarded where Self: UIViewController {
	static var bundle: Bundle { .main }
	static var storyboardName: String { "Main" }
	static var instantiate: Self {
		let storyboardId = String(describing: self)
		let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
		guard let instance = storyboard.instantiateViewController(withIdentifier: storyboardId) as? Self else {
			fatalError("Fail to instantiate view controller with identifier \(storyboardId). Check again.")
		}
		return instance
	}
}

// MARK: - __________ Configurable __________
protocol SimpleInitializer {
	init()
}
protocol Configurable {
	@discardableResult
	mutating func configure(_ configurator: (inout Self) -> Void) -> Self
}
typealias SimpleConfigurable = SimpleInitializer & Configurable
extension Configurable {
	@discardableResult
	mutating func configure(_ configurator: (inout Self) -> Void) -> Self {
		configurator(&self)
		return self
	}
}
protocol InstanceFactory {
	static func make(_ configurator: (inout Self) -> Void) -> Self
}
extension InstanceFactory where Self: SimpleConfigurable {
	static func make(_ configurator: (inout Self) -> Void) -> Self {
		var retval = Self()
		return retval.configure(configurator)
	}
}

protocol ClassConfigurable: AnyObject {}
extension ClassConfigurable {
	@discardableResult
	func configure(_ configurator: (Self) -> Void) -> Self {
		configurator(self)
		return self
	}
}
typealias SimpleClassConfigurable = SimpleInitializer & ClassConfigurable
protocol ClassNewInstanceConfigurable: SimpleClassConfigurable {}
extension ClassNewInstanceConfigurable {
	static func make(_ configurator: (Self) -> Void) -> Self {
		let retval = Self()
		return retval.configure(configurator)
	}
}

extension NSObject: ClassNewInstanceConfigurable {}

// MARK: - __________ Transformable Protocol __________
/// 转换自身为另一种类型
/// - Parameter transformer: 具体转换的实现过程
/// - Returns: 返回转换之后的实例
protocol Transformable {
	associatedtype E
	func transform<T>(_ transformer: (E) -> T) -> T
}

extension Transformable {
	func transform<T>(_ transformer: (Self) -> T) -> T {
		transformer(self)
	}
}

extension NSObject: Transformable {}
extension Set: Transformable {}
extension Array: Transformable {}
extension Dictionary: Transformable {}
extension DateComponents: Transformable {}
extension Calendar: Transformable {}

// MARK: - __________ Add Selector for UIControl Events Using a Closure __________
class ClosureSleeve<T> where T: AnyObject {
    var closure: ((T) -> Void)?
    weak var sender: T!

    init (sender: T, _ closure: ((T) -> Void)?) {
        self.closure = closure
        self.sender = sender
    }

    @objc func invoke() {
        closure?(sender)
    }
}

protocol Actionable {
    associatedtype T = Self
    func addAction(for controlEvents: UIControl.Event, _ action: ((T) -> Void)?)
}

extension UIControl: Actionable {
    private static var targetsArrayKey = UUID()
    fileprivate var targets: NSMutableArray {
        if let array = objc_getAssociatedObject(self, &Self.targetsArrayKey) as? NSMutableArray {
            return array
        } else {
            let array = NSMutableArray()
            objc_setAssociatedObject(self, &Self.targetsArrayKey, array, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return array
        }
    }
}

extension Actionable where Self: UIControl {
	func addAction(for events: UIControl.Event = .touchUpInside, _ action: ((Self) -> Void)?) {
        let sleeve = ClosureSleeve(sender: self, action)
        addTarget(sleeve, action: #selector(sleeve.invoke), for: events)
        targets.add(sleeve)
    }
}

protocol SizeExtendable {
	
	/// 垂直方向扩展
	var vertical: CGFloat { get }
	
	/// 水平方向扩展
	var horizontal: CGFloat { get }
}


public protocol ReusableView: AnyObject {
	static var reuseId: String { get }
}
extension ReusableView {
	public static var reuseId: String {
		String(describing: self)
	}
}



// MARK: - __________ OptionalType __________
protocol OptionalType {
	associatedtype Wrapped
	var optionalValue: Wrapped? { get }
}

protocol SelfReflectable {
    var itself: Self { get }
}
