//
//  BoolPlus.swift
//  zeniko
//
//  Created by Choi on 2022/8/18.
//

import Foundation

extension Bool {
    var isFalse: Bool {
        self == false
    }
}

extension Bool: SelfReflectable {
    var itself: Bool { self }
}
