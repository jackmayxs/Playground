//
//  NameSpace.swift
//  zeniko
//
//  Created by Choi on 2022/9/21.
//

import Foundation

public struct KK<Base> {
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
public protocol KKCompatible {
    /// Extended type
    associatedtype KKBase

    /// Reactive extensions.
    static var kk: KK<KKBase>.Type { get set }

    /// Reactive extensions.
    var kk: KK<KKBase> { get set }
}

extension KKCompatible {
    /// Reactive extensions.
    public static var kk: KK<Self>.Type {
        get { KK<Self>.self }
        // this enables using Reactive to "mutate" base type
        // swiftlint:disable:next unused_setter_value
        set { }
    }

    /// Reactive extensions.
    public var kk: KK<Self> {
        get { KK(self) }
        // this enables using Reactive to "mutate" base object
        // swiftlint:disable:next unused_setter_value
        set { }
    }
}

/// Extend NSObject with `rx` proxy.
extension NSObject: KKCompatible { }
