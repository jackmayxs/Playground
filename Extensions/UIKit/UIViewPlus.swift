//
//  UIViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/14.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit
import SwiftUI

extension UIView {
	
	convenience init(_ color: UIColor) {
		self.init(frame: .zero)
		backgroundColor = color
	}
	
	static func cornerRadius(_ cornerRadius: CGFloat, color: UIColor = .white) -> UIView {
		UIView.new { make in
			make.backgroundColor = color
			make.layer.cornerRadius = cornerRadius
		}
	}
}

// MARK: - __________ Getters __________
extension UIView {
	
	/// 获取View控制器实例
	var owner: UIViewController? {
		owner(UIViewController.self)
	}
	
	/// 获取View的控制器
	/// - Parameter type: 控制器类型
	/// - Returns: 控制器实例
	func owner<VC: UIViewController>(_ type: VC.Type) -> VC? {
		var parent: UIResponder? = self
		while parent != nil {
			parent = parent?.next
			if let controller = parent as? VC {
				return controller
			}
		}
		return nil
	}
}

// MARK: - __________ Functions __________
extension Array where Element: UIView {
	
	/// 将UIView的数组包装的StackView里
	/// - Returns: The stack view wrapping the given view array as arranged subviews.
	func embedInStackView(
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .leading,
		spacing: CGFloat = 0)
	-> UIStackView {
		let stackView = UIStackView(arrangedSubviews: self)
		stackView.axis = axis
		stackView.distribution = distribution
		stackView.alignment = alignment
		stackView.spacing = spacing
		return stackView
	}
}
extension UIView {
	
	/// 为视图添加圆角
	/// - Parameters:
	///   - corners: 圆角位置
	///   - radius: 圆角半径
	func roundCorners(corners: UIRectCorner = .allCorners, radius: Double = 0.0) {
		layer.masksToBounds = true
		let maskPath = UIBezierPath(
			roundedRect: bounds,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width:radius, height:radius)
		)
		let shape = CAShapeLayer()
		shape.path = maskPath.cgPath
		layer.mask = shape
	}
}
#if DEBUG
// MARK: - __________ SwiftUI __________
extension UIView {

	var previewLayout: PreviewLayout {
		let previewSize = systemLayoutSizeFitting(
			CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude),
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel
		)
		return .fixed(width: previewSize.width, height: previewSize.height)
	}
	
	private struct Preview: UIViewRepresentable {
		
		let view: UIView

		func makeUIView(context: Context) -> UIView { view }

		func updateUIView(_ uiView: UIView, context: Context) { }
	}

	var preview: some View {
		// 如何遇见切换UIView和UIView(带设备边框)的情况,可尝试把整个项目关闭在重新打开; 或清除Preview缓存:
		// .../Xcode/DerivedData/TargetFolder.../Build/Intermediates.noindex/Previews
		Preview(view: self)
//			.previewLayout(.device)
			.previewLayout(previewLayout)
	}
}
#endif
