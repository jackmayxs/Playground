//
//  TaskPlus.swift
//  KnowLED
//
//  Created by Choi on 2024/10/16.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    
    static func sleep(seconds: TimeInterval) async throws {
        guard seconds >= .leastNormalMagnitude else {
            throw "WRONG PARAMETER: \(seconds), CHECK YOUR SOURCE."
        }
        let nanoseconds = UInt64(seconds * NSEC_PER_SEC.double)
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .nanoseconds(nanoseconds), tolerance: .seconds(2))
        } else {
            try await Task.sleep(nanoseconds: nanoseconds)
        }
    }
}
