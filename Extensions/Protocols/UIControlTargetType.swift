//
//  UIControlTargetType.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import UIKit

protocol UIControlTargetType {
    associatedtype T = Self
    func addEvents(_ events: UIControl.Event, _ callback: ((T) -> Void)?)
}

extension UIControl: UIControlTargetType {
    
    enum Associated {
        static var eventActions = UUID()
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

extension UIControlTargetType where Self: UIControl {
    
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
    
    fileprivate var eventActions: [UInt: EventAction<Self>] {
        get {
            if let existedEventActions = getAssociatedObject(self, &Associated.eventActions) as? [UInt: EventAction<Self>] {
                return existedEventActions
            } else {
                let eventActions: [UInt: EventAction<Self>] = [:]
                setAssociatedObject(self, &Associated.eventActions, eventActions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return eventActions
            }
        }
        set {
            setAssociatedObject(self, &Associated.eventActions, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 此方法无效 | 不可使用
    private func addEventsV2(_ event: UIControl.Event = .touchUpInside, _ callback: @escaping (Self) -> Void) {
        
        if let eventAction = eventActions[event.rawValue] {
            eventAction.actions.append(callback)
        } else {
            let eventAction = EventAction<Self>()
            eventAction.actions.append(callback)
            var tempEventActions = self.eventActions
            tempEventActions[event.rawValue] = eventAction
            self.eventActions = tempEventActions
        }
        
        switch event {
        case .touchDown:
            addTarget(self, action: #selector(triggerTouchDown), for: event)
        case .touchDownRepeat:
            addTarget(self, action: #selector(triggerTouchDownRepeat), for: event)
        case .touchDragInside:
            addTarget(self, action: #selector(triggerTouchDragInside), for: event)
        case .touchDragOutside:
            addTarget(self, action: #selector(triggerTouchDragOutside), for: event)
        case .touchDragEnter:
            addTarget(self, action: #selector(triggerTouchDragEnter), for: event)
        case .touchDragExit:
            addTarget(self, action: #selector(triggerTouchDragExit), for: event)
        case .touchUpInside:
            addTarget(self, action: #selector(triggerTouchUpInside), for: event)
        case .touchUpOutside:
            addTarget(self, action: #selector(triggerTouchUpOutside), for: event)
        case .touchCancel:
            addTarget(self, action: #selector(triggerTouchCancel), for: event)
        case .valueChanged:
            addTarget(self, action: #selector(triggerValueChanged), for: event)
        case .primaryActionTriggered:
            addTarget(self, action: #selector(triggerPrimaryActionTriggered), for: event)
        case .editingDidBegin:
            addTarget(self, action: #selector(triggerEditingDidBegin), for: event)
        case .editingDidEnd:
            addTarget(self, action: #selector(triggerEditingDidEnd), for: event)
        case .editingChanged:
            addTarget(self, action: #selector(triggerEditingChanged), for: event)
        case .editingDidEndOnExit:
            addTarget(self, action: #selector(triggerEditingDidEndOnExit), for: event)
        case .allTouchEvents:
            addTarget(self, action: #selector(triggerAllTouchEvents), for: event)
        case .allEditingEvents:
            addTarget(self, action: #selector(triggerAllEditingEvents), for: event)
        case .applicationReserved:
            addTarget(self, action: #selector(triggerApplicationReserved), for: event)
        case .systemReserved:
            addTarget(self, action: #selector(triggerSystemReserved), for: event)
        case .allEvents:
            addTarget(self, action: #selector(triggerAllEvents), for: event)
        default:
            if #available(iOS 14.0, *) {
                switch event {
                case .menuActionTriggered:
                    addTarget(self, action: #selector(triggerMenuActionTriggered), for: event)
                default:
                    break
                }
            }
            break
        }
    }
}

extension UIControl {
    
    @objc fileprivate func triggerTouchDown() {
        eventActions[UIControl.Event.touchDown.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDownRepeat() {
        eventActions[UIControl.Event.touchDownRepeat.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDragInside() {
        eventActions[UIControl.Event.touchDragInside.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDragOutside() {
        eventActions[UIControl.Event.touchDragOutside.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDragEnter() {
        eventActions[UIControl.Event.touchDragEnter.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDragExit() {
        eventActions[UIControl.Event.touchDragExit.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchUpInside() {
        eventActions[UIControl.Event.touchUpInside.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchUpOutside() {
        eventActions[UIControl.Event.touchUpOutside.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchCancel() {
        eventActions[UIControl.Event.touchCancel.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerValueChanged() {
        eventActions[UIControl.Event.valueChanged.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerPrimaryActionTriggered() {
        eventActions[UIControl.Event.primaryActionTriggered.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @available(iOS 14.0, *)
    @objc fileprivate func triggerMenuActionTriggered() {
        eventActions[UIControl.Event.menuActionTriggered.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerEditingDidBegin() {
        eventActions[UIControl.Event.editingDidBegin.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerEditingChanged() {
        eventActions[UIControl.Event.editingChanged.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerEditingDidEnd() {
        eventActions[UIControl.Event.editingDidEnd.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerEditingDidEndOnExit() {
        eventActions[UIControl.Event.editingDidEndOnExit.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerAllTouchEvents() {
        eventActions[UIControl.Event.allTouchEvents.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerAllEditingEvents() {
        eventActions[UIControl.Event.allEditingEvents.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerApplicationReserved() {
        eventActions[UIControl.Event.applicationReserved.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerSystemReserved() {
        eventActions[UIControl.Event.systemReserved.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
        }
    }
    
    @objc fileprivate func triggerAllEvents() {
        eventActions[UIControl.Event.allEvents.rawValue].unwrap { eventAction in
            eventAction.actions.forEach { action in
                action(self)
            }
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

fileprivate final class EventAction<T: UIControl> {
    var actions: [(T) -> Void] = .empty
}
