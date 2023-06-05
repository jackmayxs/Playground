//
//  CombinePlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/30.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
extension Set where Element: Cancellable {
	mutating func insert(@ArrayBuilder<Element> _ builder: () -> [Element]) {
		let cancellables = builder()
		let newSet = Set(cancellables)
		formUnion(newSet)
	}
}

extension Publisher where Output: OptionalType {
    var unwrapped: AnyPublisher<Output.Wrapped, Failure> {
        compactMap(\.optionalValue)
            .eraseToAnyPublisher()
    }
}
