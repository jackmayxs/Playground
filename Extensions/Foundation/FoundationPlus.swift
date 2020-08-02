//
//  FoundationPlus.swift
//  ExtensionDemo
//
//  Created by Ori on 2020/8/2.
//  Copyright © 2020 Choi. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var safeValue: String { self ?? "" }
}
