//
//  ResultBuilders.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/7/29.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

@resultBuilder
struct CommonBuilder<Element> {
	static func buildBlock(_ components: Element...) -> [Element] {
		components
	}
	static func buildEither(first component: Element) -> Element {
		return component
	}
	static func buildEither(second component: Element) -> Element {
		return component
	}
	static func buildArray(_ components: [Element]) -> [Element] {
		components
	}
}
