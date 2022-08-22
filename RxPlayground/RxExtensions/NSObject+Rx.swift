//
//  NSObject+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/4.
//

import Foundation
import RxSwift
import ObjectiveC

fileprivate var disposeBagContext: UInt8 = 0

extension Reactive where Base: AnyObject {
    func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(base)
        let result = action()
        objc_sync_exit(base)
        return result
    }
}

public extension Reactive where Base: AnyObject {

    /// a unique DisposeBag that is related to the Reactive.Base instance only for Reference type
    var disposeBag: DisposeBag {
        get {
            synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(base, &disposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(base, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        
        nonmutating set {
            synchronizedBag {
                objc_setAssociatedObject(base, &disposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

// MARK: - Error & Activity Tracker
protocol ErrorTracker: NSObject {
    func popError(_ error: Error)
}

protocol ActivityTracker: NSObject {
    func processing()
    func doneProcessing()
}

fileprivate var activityIndicatorKey = 0

extension Reactive where Base: ActivityTracker {
    var activity: ActivityIndicator {
        synchronizedBag {
            if let indicator = objc_getAssociatedObject(base, &activityIndicatorKey) as? ActivityIndicator {
                return indicator
            } else {
                let indicator = ActivityIndicator()
                base.rx.disposeBag.insert {
                    indicator.drive(with: base) { weakBase, processing in
                        if processing {
                            weakBase.processing()
                        } else {
                            weakBase.doneProcessing()
                        }
                    }
                }
                objc_setAssociatedObject(base, &activityIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return indicator
            }
        }
    }
}

extension ObservableConvertibleType {
    
    func trackError<T>(_ tracker: T) -> Observable<Element> where T: ErrorTracker {
        asObservable()
            .do { _ in
                
            } onError: {
                [weak tracker] error in tracker?.popError(error)
            }
    }
}
