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
	
	func snapshotScreen(scrollView: UIScrollView) -> UIImage?{
		if UIScreen.main.responds(to: #selector(getter: UIScreen.scale)) {
			UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, UIScreen.main.scale)
		} else {
			UIGraphicsBeginImageContext(scrollView.contentSize)
		}
		
		let savedContentOffset = scrollView.contentOffset
		let savedFrame = scrollView.frame
		let contentSize = scrollView.contentSize
		let oldBounds = scrollView.layer.bounds
		
		if #available(iOS 13, *) {
			//iOS 13 系统截屏需要改变tableview 的bounds
			scrollView.layer.bounds = CGRect(x: oldBounds.origin.x, y: oldBounds.origin.y, width: contentSize.width, height: contentSize.height)
		}
		//偏移量归零
		scrollView.contentOffset = CGPoint.zero
		//frame变为contentSize
		scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
		
		//截图
		if let context = UIGraphicsGetCurrentContext() {
			scrollView.layer.render(in: context)
		}
		if #available(iOS 13, *) {
			scrollView.layer.bounds = oldBounds
		}
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		//还原frame 和 偏移量
		scrollView.contentOffset = savedContentOffset
		scrollView.frame = savedFrame
		return image
	}
	
	private func getTableViewScreenshot(tableView: UITableView,whereView: UIView) -> UIImage?{
		// 创建一个scrollView
		let scrollView = UIScrollView()
		// 设置颜色
		scrollView.backgroundColor = UIColor.white
		// 设置位置
		scrollView.frame = whereView.bounds
		// 设置滚动位置
		scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: tableView.contentSize.height)
		// 将tableView加载到视图中
		scrollView.addSubview(tableView)
		// 设置位置
		let constraints = [
			tableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			tableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
			tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
			tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
		]
		NSLayoutConstraint.activate(constraints)
		/// 添加到指定视图
		whereView.addSubview(scrollView)
		/// 截图
		let image = snapshotScreen(scrollView: scrollView)
		/// 移除scrollView
		scrollView.removeFromSuperview()
		return image
	}

	var snapshot: UIImage? {
		switch self {
			case let unwrapped where unwrapped is UITableView:
				let tableView = unwrapped as! UITableView
				return getTableViewScreenshot(tableView: tableView, whereView: superview!)
			default:
				// 参数①：截屏区域  参数②：是否透明  参数③：清晰度
				UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.main.scale)
				layer.render(in: UIGraphicsGetCurrentContext()!)
				let image = UIGraphicsGetImageFromCurrentImageContext()

				UIGraphicsEndImageContext()
				return image
		}
	}
	
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
