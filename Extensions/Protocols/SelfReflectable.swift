//
//  SelfReflectable.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import Foundation

protocol SelfReflectable {
    var itself: Self { get }
}

extension Bool: SelfReflectable {
    var itself: Bool { self }
}

extension Optional: SelfReflectable {
    var itself: Optional<Wrapped> { self }
}

extension Array: SelfReflectable {
    var itself: Array<Element> { self }
}
