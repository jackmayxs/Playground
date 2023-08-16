//
//  EventReceiver.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import UIKit

protocol EventReceiver {
    associatedtype Control: UIControl
    func addEvents(_ events: UIControl.Event, _ callback: ((Control) -> Void)?) -> String
}

extension UIControl: EventReceiver {
    
    enum Associated {
        static var targetsArray = UUID()
    }
    
    /// 用于保存添加的target(ClosureSleeve)
    fileprivate var targets: NSMutableArray {
        if let array = getAssociatedObject(self, &Associated.targetsArray) as? NSMutableArray {
            return array
        } else {
            let array = NSMutableArray()
            setAssociatedObject(self, &Associated.targetsArray, array, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return array
        }
    }
}

extension EventReceiver where Self: UIControl {
    
    
    @discardableResult
    /// 添加Closure回调
    /// - Parameters:
    ///   - events: 触发的事件集合
    ///   - callback: 回调Closure
    /// - Returns: 标记Action/ClosureSleeve的Identifier, 用于后续移除操作
    func addEvents(_ events: UIControl.Event = .touchUpInside, _ callback: ((Self) -> Void)?) -> String {
        if #available(iOS 14, *) {
            let action = UIAction { action in
                guard let callback, let sender = action.sender as? Self else { return }
                callback(sender)
            }
            addAction(action, for: events)
            return action.identifier.rawValue
        } else {
            let target = ClosureSleeve(sender: self, callback)
            addTarget(target, action: #selector(target.action), for: events)
            targets.add(target)
            return target.identifier
        }
    }
    
    /// 移除回调Closure
    /// - Parameters:
    ///   - identifier: 添加时返回的Identifier
    ///   - events: 相关的事件
    func removeEvents(identifiedBy identifier: String, for events: UIControl.Event) {
        if #available(iOS 14.0, *) {
            removeAction(identifiedBy: UIAction.Identifier(identifier), for: events)
        } else {
            let foundSleeve = targets.as(ClosureSleeve<Self>.self).first { sleeve in
                sleeve.identifier == identifier
            }
            if let foundSleeve {
                removeTarget(foundSleeve, action: #selector(foundSleeve.action), for: events)
                targets.remove(foundSleeve)
            }
        }
    }
}

// MARK: - 相关类型
final class ClosureSleeve<T> where T: AnyObject {
    
    weak var sender: T!
    
    var actionCallback: ((T) -> Void)?
    
    let identifier = String.random
    
    init(sender: T, _ closure: ((T) -> Void)?) {
        self.sender = sender
        self.actionCallback = closure
    }
    
    @objc func action() {
        actionCallback.unwrap { actionCallback in
            actionCallback(sender)
        }
    }
}
