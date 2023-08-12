//
//  Actionable.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import UIKit

protocol Actionable {
    associatedtype T = Self
    func addAction(for controlEvents: UIControl.Event, _ action: ((T) -> Void)?)
}

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
