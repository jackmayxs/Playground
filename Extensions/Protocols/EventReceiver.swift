//
//  EventReceiver.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import UIKit

protocol EventReceiver {
    associatedtype Control: UIControl
    func addEvents(_ events: UIControl.Event, _ callback: ((Control) -> Void)?)
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
    
    func addEvents(_ events: UIControl.Event = .touchUpInside, _ callback: ((Self) -> Void)?) {
        if #available(iOS 14, *) {
            let action = UIAction { action in
                guard let callback, let sender = action.sender as? Self else { return }
                callback(sender)
            }
            addAction(action, for: events)
        } else {
            let target = ClosureSleeve(sender: self, callback)
            addTarget(target, action: #selector(target.action), for: events)
            targets.add(target)
        }
    }
}

// MARK: - 相关类型
final class ClosureSleeve<T> where T: AnyObject {
    
    weak var sender: T!
    
    var actionCallback: ((T) -> Void)?
    
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
