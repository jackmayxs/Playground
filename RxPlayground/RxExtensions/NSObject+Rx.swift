//
//  NSObject+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/4.
//

import Foundation
import RxSwift
import RxCocoa
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
protocol ErrorTracker: UIResponder {
    func trackError(_ error: Error?)
}

protocol ActivityTracker: NSObject {
    func trackActivity(_ isProcessing: Bool)
}

fileprivate var activityIndicatorKey = UUID()

extension Reactive where Base: ActivityTracker {
    var activity: ActivityIndicator {
        synchronizedBag {
            if let indicator = objc_getAssociatedObject(base, &activityIndicatorKey) as? ActivityIndicator {
                return indicator
            } else {
                let indicator = ActivityIndicator()
                base.rx.disposeBag.insert {
                    indicator.drive(with: base) { weakBase, processing in
                        weakBase.trackActivity(processing)
                    }
                }
                objc_setAssociatedObject(base, &activityIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return indicator
            }
        }
    }
}

// MARK: - 扩展事件类型为<#EventConvertible#>的事件序列
extension ObservableConvertibleType where Element: EventConvertible {
    
    /// 跟踪错误事件
    /// - Parameters:
    ///   - tracker: 错误跟踪者
    ///   - respondDepth: 响应深度 | nextResponder的深度, 如UIView的父视图
    /// - Returns: 观察序列
    func trackErrorEvent(_ tracker: ErrorTracker?, respondDepth: Int = 0) -> Observable<Event<Element.Element>> {
        asObservable()
            .dematerialize()
            .trackError(tracker, respondDepth: respondDepth)
            .materialize()
    }
}

extension ObservableConvertibleType {
    
    /// 跟踪错误
    /// - Parameters:
    ///   - tracker: 错误跟踪者
    ///   - respondDepth: 响应深度 | nextResponder的深度, 如UIView的父视图
    /// - Returns: 观察序列
    func trackError(_ tracker: ErrorTracker?, respondDepth: Int = 0) -> Observable<Element> {
        asObservable()
            .do { _ in
                
            } onError: {
                [weak tracker] error in
                var responder = tracker
                for _ in 0 ..< respondDepth {
                    if let nextTracker = responder?.next as? ErrorTracker {
                        responder = nextTracker
                    }
                }
                responder?.trackError(error)
            }
    }
}
