//
//  DictionaryPlus.swift
//
//  Created by Choi on 2022/10/21.
//

import Foundation

// MARK: - Optional Value Dictionary
extension Dictionary where Value: OptionalType {
    var unwrapped: Dictionary<Key, Value.Wrapped> {
        reduce(into: [Key:Value.Wrapped]()) { partialResult, tuple in
            guard let value = tuple.value.optionalValue else { return }
            partialResult[tuple.key] = value
        }
    }
}
