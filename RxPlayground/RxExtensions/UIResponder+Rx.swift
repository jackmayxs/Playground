//
//  UIResponder+Rx.swift
//  KnowLED
//
//  Created by Choi on 2024/4/22.
//

import UIKit
import RxSwift
import RxCocoa

typealias ResponderTouchesWithEvent = (Set<UITouch>, UIEvent?)

extension Reactive where Base: UIResponder {
    
    var mergedTouchesWithEvent: Observable<ResponderTouchesWithEvent> {
        Observable<ResponderTouchesWithEvent>.merge {
            touchesBegan
            touchesMoved
            touchesEnded
            touchesCancelled
        }
    }
    
    var touchesBegan: Observable<ResponderTouchesWithEvent> {
        methodInvoked(#selector(base.touchesBegan(_:with:))).compactMap { parameters in
            guard let touches = parameters.first as? Set<UITouch> else { return nil }
            return (touches, parameters.last as? UIEvent)
        }
    }
    
    var touchesMoved: Observable<ResponderTouchesWithEvent> {
        methodInvoked(#selector(base.touchesMoved(_:with:))).compactMap { parameters in
            guard let touches = parameters.first as? Set<UITouch> else { return nil }
            return (touches, parameters.last as? UIEvent)
        }
    }
    
    var touchesEnded: Observable<ResponderTouchesWithEvent> {
        methodInvoked(#selector(base.touchesEnded(_:with:))).compactMap { parameters in
            guard let touches = parameters.first as? Set<UITouch> else { return nil }
            return (touches, parameters.last as? UIEvent)
        }
    }
    
    var touchesCancelled: Observable<ResponderTouchesWithEvent> {
        methodInvoked(#selector(base.touchesCancelled(_:with:))).compactMap { parameters in
            guard let touches = parameters.first as? Set<UITouch> else { return nil }
            return (touches, parameters.last as? UIEvent)
        }
    }
}
