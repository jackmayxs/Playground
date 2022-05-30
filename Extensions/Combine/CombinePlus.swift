//
//  CombinePlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/30.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation
import Combine

extension Set where Element: Cancellable {
	mutating func insert(@ArrayBuilder<Element> _ builder: () -> [Element]) {
		let cancellables = builder()
		let newSet = Set(cancellables)
		formUnion(newSet)
	}
}
