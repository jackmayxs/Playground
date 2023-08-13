//
//  Actionable.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import UIKit

protocol Actionable {}

class ClosureSleeve<T> where T: AnyObject {
    
    weak var sender: T!
    
    var actionCallback: ((T) -> Void)?
    
    init (sender: T, _ actionCallback: ((T) -> Void)?) {
        self.actionCallback = actionCallback
        self.sender = sender
    }
    
    @objc func action() {
        actionCallback.unwrap { callback in
            callback(sender)
        }
    }
}

extension UIControl: Actionable {
    
    fileprivate static var eventActionsKey = UUID()
}

fileprivate final class EventActions<T: Actionable> {
    var callbacks: [(T) -> Void] = .empty
}

extension Actionable where Self: UIControl {
    
    fileprivate var eventActions: [UInt: EventActions<Self>] {
        get {
            if let array = objc_getAssociatedObject(self, &Self.eventActionsKey) as? [UInt: EventActions<Self>] {
                return array
            } else {
                let tempEventActions: [UInt: EventActions<Self>] = [:]
                objc_setAssociatedObject(self, &Self.eventActionsKey, tempEventActions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return tempEventActions
            }
        }
        set {
            objc_setAssociatedObject(self, &Self.eventActionsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func trigger(_ event: UIControl.Event = .touchUpInside, _ callback: @escaping ((Self) -> Void)) {
        
        if #available(iOS 14, *) {
            let action = UIAction { action in
                guard let sender = action.sender as? Self else { return }
                callback(sender)
            }
            return addAction(action, for: event)
        }
        
        if let eventActions = self.eventActions[event.rawValue] {
            eventActions.callbacks.append(callback)
        } else {
            let eventActions = EventActions<Self>()
            eventActions.callbacks.append(callback)
            self.eventActions[event.rawValue] = eventActions
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
            break
        }
    }
}





extension UIControl {
    
    @objc fileprivate func triggerTouchDown() {
        eventActions[UIControl.Event.touchDown.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDownRepeat() {
        eventActions[UIControl.Event.touchDownRepeat.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDragInside() {
        eventActions[UIControl.Event.touchDragInside.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDragOutside() {
        eventActions[UIControl.Event.touchDragOutside.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDragEnter() {
        eventActions[UIControl.Event.touchDragEnter.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchDragExit() {
        eventActions[UIControl.Event.touchDragExit.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchUpInside() {
        eventActions[UIControl.Event.touchUpInside.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchUpOutside() {
        eventActions[UIControl.Event.touchUpOutside.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerTouchCancel() {
        eventActions[UIControl.Event.touchCancel.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerValueChanged() {
        eventActions[UIControl.Event.valueChanged.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerPrimaryActionTriggered() {
        eventActions[UIControl.Event.primaryActionTriggered.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerEditingDidBegin() {
        eventActions[UIControl.Event.editingDidBegin.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerEditingChanged() {
        eventActions[UIControl.Event.editingChanged.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerEditingDidEnd() {
        eventActions[UIControl.Event.editingDidEnd.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerEditingDidEndOnExit() {
        eventActions[UIControl.Event.editingDidEndOnExit.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerAllTouchEvents() {
        eventActions[UIControl.Event.allTouchEvents.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerAllEditingEvents() {
        eventActions[UIControl.Event.allEditingEvents.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerApplicationReserved() {
        eventActions[UIControl.Event.applicationReserved.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerSystemReserved() {
        eventActions[UIControl.Event.systemReserved.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    @objc fileprivate func triggerAllEvents() {
        eventActions[UIControl.Event.allEvents.rawValue].unwrap { actions in
            actions.callbacks.forEach { execute in
                execute(self)
            }
        }
    }
    
    /**
     * Retrieve the address for this UIControl as a String.
     */
    private var address: String {
        let addr = Unmanaged.passUnretained(self).toOpaque()
        return "\(addr)"
    }
}
