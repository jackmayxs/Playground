//
//  ResultBuilders.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/7/29.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

@resultBuilder
enum ArrayBuilder<E> {
	
	static func buildEither(first component: [E]) -> [E] {
		component
	}

	static func buildEither(second component: [E]) -> [E] {
		component
	}

	static func buildOptional(_ component: [E]?) -> [E] {
		component ?? []
	}

	static func buildExpression(_ expression: E) -> [E] {
		[expression]
	}

	static func buildExpression(_ expression: ()) -> [E] {
		[]
	}

	static func buildBlock(_ components: [E]...) -> [E] {
		components.flatMap { $0 }
	}
	
	static func buildArray(_ components: [[E]]) -> [E] {
		Array(components.joined())
	}
}

@resultBuilder
struct SingleValueBuilder<E> {
	static func buildBlock(_ components: E) -> E {
		components
	}
	static func buildEither(first component: E) -> E {
		component
	}
	static func buildEither(second component: E) -> E {
		component
	}
	static func buildOptional(_ component: E) -> E {
		component
	}
	static func buildLimitedAvailability(_ component: E) -> E {
		component
	}
}

// MARK: - __________ Constraints Builder __________
protocol ConstraintGroup {
	var constraints: [NSLayoutConstraint] { get }
}
extension NSLayoutConstraint: ConstraintGroup {
	var constraints: [NSLayoutConstraint] { [self] }
}
extension Array: ConstraintGroup where Element == NSLayoutConstraint {
	var constraints: [NSLayoutConstraint] { self }
}

@resultBuilder
struct ConstraintsBuilder {
	static func buildBlock(_ components: ConstraintGroup...) -> [NSLayoutConstraint] {
		components.flatMap(\.constraints)
	}
	static func buildOptional(_ component: [ConstraintGroup]?) -> [NSLayoutConstraint] {
		component?.flatMap(\.constraints) ?? []
	}
	static func buildEither(first component: [ConstraintGroup]) -> [NSLayoutConstraint] {
		component.flatMap(\.constraints)
	}
	static func buildEither(second component: [ConstraintGroup]) -> [NSLayoutConstraint] {
		component.flatMap(\.constraints)
	}
}

// MARK: Best Practice
extension NSLayoutConstraint {
	static func activate(@ConstraintsBuilder constraintsBuilder: () -> [NSLayoutConstraint]) {
		let constraints = constraintsBuilder()
		activate(constraints)
	}
}

protocol SubviewContaining {}
extension UIView: SubviewContaining {}
extension SubviewContaining where Self: UIView {
	func add<SubView: UIView>(subView: SubView, @ConstraintsBuilder constraintsBuilder: (SubView) -> [NSLayoutConstraint]) {
		subView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(subView)
		let constraints = constraintsBuilder(subView)
		NSLayoutConstraint.activate(constraints)
	}
}
fileprivate func testConstraintsBuilder() {
	let container = UIView()
	let subView = UIView()
	let offset: CGFloat? = nil
	let value: Int = 0
	container.add(subView: subView) { sub in
		sub.widthAnchor.constraint(equalToConstant: 200)
		if let offset = offset {
			sub.topAnchor.constraint(equalTo: container.topAnchor, constant: offset)
		}
		if value > 0 {
			sub.bottomAnchor.constraint(equalTo: container.bottomAnchor)
		} else {
			sub.rightAnchor.constraint(equalTo: container.rightAnchor)
		}
	}
}

// MARK: - __________ Subviews Builder __________
protocol SubviewGroup {
	var subViews: [UIView] { get }
}
extension UIView: SubviewGroup {
	var subViews: [UIView] { [self] }
}
extension Array: SubviewGroup where Element == UIView {
	var subViews: [UIView] { self }
}

@resultBuilder
struct SubviewsBuilder {
	static func buildBlock(_ components: SubviewGroup...) -> [UIView] {
		components.flatMap(\.subViews)
	}
	static func buildOptional(_ component: [SubviewGroup]?) -> [UIView] {
		component?.flatMap(\.subViews) ?? []
	}
	static func buildEither(first component: [SubviewGroup]) -> [UIView] {
		component.flatMap(\.subViews)
	}
	static func buildEither(second component: [SubviewGroup]) -> [UIView] {
		component.flatMap(\.subViews)
	}
}

// MARK: - __________ NSAttributedString Builder __________
protocol NSAttributedStringGroup {
	var attributedStrings: [NSAttributedString] { get }
}
extension NSAttributedString: NSAttributedStringGroup {
	var attributedStrings: [NSAttributedString] { [self] }
}
extension Array: NSAttributedStringGroup where Element == NSAttributedString {
	var attributedStrings: [NSAttributedString] { self }
}

@resultBuilder
struct NSAttributedStringsBuilder {
	static func buildBlock(_ components: NSAttributedStringGroup...) -> [NSAttributedString] {
		components.flatMap(\.attributedStrings)
	}
	static func buildOptional(_ component: [NSAttributedStringGroup]?) -> [NSAttributedString] {
		component?.flatMap(\.attributedStrings) ?? []
	}
	static func buildEither(first component: [NSAttributedStringGroup]) -> [NSAttributedString] {
		component.flatMap(\.attributedStrings)
	}
	static func buildEither(second component: [NSAttributedStringGroup]) -> [NSAttributedString] {
		component.flatMap(\.attributedStrings)
	}
}
