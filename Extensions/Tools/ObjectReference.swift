//
//  ObjectReference.swift
//  KnowLED
//
//  Created by Choi on 2024/1/3.
//

import Foundation

struct ObjectReference<T> where T: AnyObject {
    weak var object: T?
}
