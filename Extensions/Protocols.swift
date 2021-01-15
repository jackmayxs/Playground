//
//  Protocols.swift
//
//  Created by Choi on 2020/9/6.
//  Copyright © 2020年 All rights reserved.
//

import UIKit

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

// MARK: - __________ Add Selector for UIControl Events Using a Closure __________
protocol Actionable {
    associatedtype T = Self
    func addAction(for controlEvents: UIControl.Event, _ action: ((T) -> Void)?)
}

private class ClosureSleeve<T> {
    let closure: ((T) -> Void)?
    let sender: T

    init (sender: T, _ closure: ((T) -> Void)?) {
        self.closure = closure
        self.sender = sender
    }

    @objc func invoke() {
        closure?(sender)
    }
}

extension Actionable where Self: UIControl {
	func addAction(for events: UIControl.Event = .touchUpInside, _ action: ((Self) -> Void)?) {
        let previousSleeve = objc_getAssociatedObject(self, String(events.rawValue))
        objc_removeAssociatedObjects(previousSleeve as Any)
        removeTarget(previousSleeve, action: nil, for: events)

        let sleeve = ClosureSleeve(sender: self, action)
        addTarget(sleeve, action: #selector(ClosureSleeve<Self>.invoke), for: events)
        objc_setAssociatedObject(self, String(events.rawValue), sleeve, .OBJC_ASSOCIATION_RETAIN)
    }
}
