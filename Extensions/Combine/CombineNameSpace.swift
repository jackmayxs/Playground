//
//  CombineNameSpace.swift
//  KnowLED
//
//  Created by Choi on 2023/5/26.
//

import Foundation
import Combine

public struct CB<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has reactive extensions.
public protocol CombineCompatible {
    /// Extended type
    associatedtype ReactiveBase

    /// Reactive extensions.
    static var cb: CB<ReactiveBase>.Type { get set }

    /// Reactive extensions.
    var cb: CB<ReactiveBase> { get set }
}

extension CombineCompatible {
    /// Reactive extensions.
    public static var cb: CB<Self>.Type {
        get { CB<Self>.self }
        // this enables using Reactive to "mutate" base type
        // swiftlint:disable:next unused_setter_value
        set { }
    }

    /// Reactive extensions.
    public var cb: CB<Self> {
        get { CB(self) }
        // this enables using Reactive to "mutate" base object
        // swiftlint:disable:next unused_setter_value
        set { }
    }
}

/// Extend NSObject with `rx` proxy.
extension NSObject: CombineCompatible { }


fileprivate var disposeSetContext: UInt8 = 0

extension CB where Base: AnyObject {
    func synchronized<T>( _ action: () -> T) -> T {
        objc_sync_enter(base)
        let result = action()
        objc_sync_exit(base)
        return result
    }
}

public extension CB where Base: AnyObject {
    
    @available(iOS 13.0, *)
    var disposeSet: Set<AnyCancellable> {
        get {
            synchronized {
                if let disposeSet = objc_getAssociatedObject(base, &disposeSetContext) as? Set<AnyCancellable> {
                    return disposeSet
                }
                let disposeSet = Set<AnyCancellable>()
                objc_setAssociatedObject(base, &disposeSetContext, disposeSet, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeSet
            }
        }
        nonmutating set {
            synchronized {
                objc_setAssociatedObject(base, &disposeSetContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
