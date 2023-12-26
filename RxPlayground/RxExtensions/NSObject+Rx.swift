//
//  NSObject+Rx.swift
//
//  Created by Choi on 2022/8/4.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectiveC

fileprivate var disposeBagContext: UInt8 = 0
fileprivate var anyUpdateRelayContext: UInt8 = 0

public extension Reactive where Base: AnyObject {
    
    /// 标记是否准备好
    var isPrepared: Bool {
        get {
            let maybePrepared = anyUpdateRelay.value as? Bool
            return maybePrepared ?? false
        }
        nonmutating set {
            anyUpdateRelay.accept(newValue)
        }
    }
    
    /// 常用于事件绑定之前的约束, 如利用.skip(until: rx.prepared)操作符
    /// 数据填充之后设置isPrepared为true以接收事件
    /// 内部使用了.take(until: deallocated)
    var prepared: Observable<Bool> {
        anyUpdate.as(Bool.self, or: false)
    }
    
    /// 更新数据流(跳过初始值) | 内部使用了.take(until: deallocated)
    var anyNewUpdate: Observable<Any> {
        anyUpdate.skip(1)
    }
    
    /// 更新数据流(包括初始值) | 内部使用了.take(until: deallocated)
    var anyUpdate: Observable<Any> {
        anyUpdateRelay.take(until: deallocated)
    }
    
    /// 通用的任意类型数据更新的BehaviorRelay | 包含初始值
    var anyUpdateRelay: BehaviorRelay<Any> {
        synchronized(lock: base) {
            guard let existedRelay = getAssociatedObject(base, &anyUpdateRelayContext) as? BehaviorRelay<Any> else {
                /// 创建Relay | 起始值为Void
                let newRelay = BehaviorRelay<Any>(value: ())
                setAssociatedObject(base, &anyUpdateRelayContext, newRelay, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newRelay
            }
            return existedRelay
        }
    }
    
    /// a unique DisposeBag that is related to the Reactive.Base instance only for Reference type
    var disposeBag: DisposeBag {
        get {
            synchronized(lock: base) {
                guard let existedBag = getAssociatedObject(base, &disposeBagContext) as? DisposeBag else {
                    let newBag = DisposeBag()
                    setAssociatedObject(base, &disposeBagContext, newBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    return newBag
                }
                return existedBag
            }
        }
        
        nonmutating set(newBag) {
            synchronized(lock: base) {
                setAssociatedObject(base, &disposeBagContext, newBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    /// disposeBag置空 | 清空之前所有的订阅
    func clearDisposeBag() {
        disposeBag = DisposeBag()
    }
}

// MARK: - Trackers Protocol
protocol ProgressTrackable {
    var progress: Double { get }
}

protocol ProgressTracker: AnyObject {
    /// 如果progress为空, 则表示未完成
    func trackProgress(_ progress: Double?)
}

protocol ErrorTracker: UIResponder {
    func trackError(_ error: Error?, isFatal: Bool)
}

protocol ActivityTracker: NSObject {
    func trackActivity(_ isProcessing: Bool)
}

fileprivate var activityIndicatorKey = UUID()

extension Reactive where Base: ActivityTracker {
    var activity: ActivityIndicator {
        synchronized(lock: base) {
            if let indicator = getAssociatedObject(base, &activityIndicatorKey) as? ActivityIndicator {
                return indicator
            } else {
                let indicator = ActivityIndicator()
                disposeBag.insert {
                    indicator.drive(with: base) { weakBase, processing in
                        weakBase.trackActivity(processing)
                    }
                }
                setAssociatedObject(base, &activityIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
    func trackError(_ tracker: ErrorTracker?, isFatal: Bool = true, respondDepth: Int = 0) -> Observable<Element> {
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
                responder?.trackError(error, isFatal: isFatal)
            }
    }
}

extension ObservableConvertibleType where Element: ProgressTrackable {
    
    func trackProgress(_ tracker: any ProgressTracker) -> Observable<Element> {
        asObservable()
            .do {
                [weak tracker] element in
                tracker?.trackProgress(element.progress)
            } onError: {
                [weak tracker] _ in
                tracker?.trackProgress(.none)
            } onCompleted: {
                [weak tracker] in
                tracker?.trackProgress(1.0)
            }
    }
}
