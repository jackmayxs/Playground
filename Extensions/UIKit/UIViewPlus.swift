//
//  UIViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/14.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit
import SwiftUI

protocol Tapable {
    associatedtype T = Self
    func addTappedExecution(_ execute: ((T) -> Void)?)
}

extension UIView: Tapable {
    fileprivate static var targetsArrayKey = UUID()
    fileprivate static var tappedClosureKey = UUID()
    fileprivate var targets: NSMutableArray {
        if let array = objc_getAssociatedObject(self, &Self.targetsArrayKey) as? NSMutableArray {
            return array
        } else {
            let array = NSMutableArray()
            objc_setAssociatedObject(self, &Self.targetsArrayKey, array, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return array
        }
    }
}

extension Tapable where Self: UIView {
    
    var tapped: ((Self) -> Void)? {
        get {
            if let target = objc_getAssociatedObject(self, &Self.tappedClosureKey) as? ClosureSleeve<Self> {
                return target.closure
            } else {
                return nil
            }
        }
        set {
            if let target = objc_getAssociatedObject(self, &Self.tappedClosureKey) as? ClosureSleeve<Self> {
                target.closure = newValue
            } else {
                let target = ClosureSleeve(sender: self, newValue)
                let tapGesture = UITapGestureRecognizer(target: target, action: #selector(target.invoke))
                addGestureRecognizer(tapGesture)
                objc_setAssociatedObject(self, &Self.tappedClosureKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func addTappedExecution(_ execute: ((Self) -> Void)?) {
        let target = ClosureSleeve(sender: self, execute)
        let tapGesture = UITapGestureRecognizer(target: target, action: #selector(target.invoke))
        addGestureRecognizer(tapGesture)
        targets.add(target)
    }
}

extension UIView {
	
	convenience init(_ color: UIColor) {
		self.init(frame: .zero)
		backgroundColor = color
	}
	
	static func cornerRadius(_ cornerRadius: CGFloat, color: UIColor = .white) -> UIView {
		UIView.make { make in
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
	
    @discardableResult
    /// 固定尺寸
    /// - Returns: 自己
    func fix(size: CGSize) -> Self {
        fix(width: size.width, height: size.height)
    }
    
    @discardableResult
    /// 固定宽高
    /// - Returns: 自己
    func fix(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    /// 限制最大宽高
    /// - Returns: 自己
    func limit(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) -> Self {
        if let width = maxWidth {
            widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
        }
        if let height = maxHeight {
            heightAnchor.constraint(lessThanOrEqualToConstant: height).isActive = true
        }
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
	
	/// 添加子视图(可变参数)
	/// - Parameter subviews: 子视图序列
	func addSubviews(_ subviews: UIView...) {
		addSubviews(subviews)
	}
	
	/// 添加子视图(通过@ArrayBuilder创建)
	/// - Parameter builder: 子视图构建方法
	func addSubviews(@ArrayBuilder<UIView> builder: () -> [UIView]) {
		let subviews = builder()
		addSubviews(subviews)
	}
	
	/// 添加子视图集合
	/// - Parameter subviews: UIView集合
	func addSubviews<T>(_ subviews: T) where T: Sequence, T.Element: UIView {
		subviews.forEach { subview in
			addSubview(subview)
		}
	}
	
	/// 自适应Size | 内部子控件Autolayout
	/// 注意: 调用此方法之前要保证外部的约束要提前设置好
	/// 比如UITableView.headerView的宽度约束要提前设置成等于TableView,否则会得到意料之外的结果
	/// 或者调用layoutIfNeeded然后重新赋值UITableView.headerView
	func fitSizeIfNeeded() {
		let systemLayoutSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		let height = systemLayoutSize.height
		let width = systemLayoutSize.width
		// Comparison necessary to avoid infinite loop
		if height != bounds.height {
			bounds.size.height = height
		}
		if width != bounds.width {
			bounds.size.width = width
		}
	}
	
	/// 获取父视图
	/// - Parameter type: 父视图类型
	/// - Returns: 有效的父视图
	func parentSuperView<SuperView: UIView>(_ type: SuperView.Type) -> SuperView? {
		guard let validSuperview = superview else { return nil }
		guard let matchedSuperview = validSuperview as? SuperView else {
			return validSuperview.parentSuperView(SuperView.self)
		}
		return matchedSuperview
	}
	
	/// 硬化 | 不可拉伸 | 不可压缩
	/// - Parameters:
	///   - axis: 设置轴线 | 默认为空(两轴同时硬化)
	///   - intensity: 硬化强度
	/// - Returns: 控件本身
	/// - Tips: 谨慎使用这个方法: 调用这四个方法之后, 会导致UIButtonPlus分类中重写的intrinsicContentSize返回的size失效
	@discardableResult
	func harden(axis: NSLayoutConstraint.Axis? = nil, intensity: UILayoutPriority = .required) -> Self {
		func hardenVertical() {
			setContentCompressionResistancePriority(intensity, for: .vertical)
			setContentHuggingPriority(intensity, for: .vertical)
		}
		func hardenHorizontal() {
			setContentCompressionResistancePriority(intensity, for: .horizontal)
			setContentHuggingPriority(intensity, for: .horizontal)
		}
		guard let axis = axis else {
			hardenVertical()
			hardenHorizontal()
			return self
		}
		switch axis {
		case .horizontal:
			hardenHorizontal()
		case .vertical:
			hardenVertical()
		@unknown default:
			break
		}
		return self
	}
	
	// MARK: - __________ 圆角 + 阴影 __________
	final class _UIShadowView: UIView { }
	private enum Associated {
		static var shadowViewKey = UUID()
	}
	private var shadowView: _UIShadowView {
		guard let shadow = objc_getAssociatedObject(self, &Associated.shadowViewKey) as? _UIShadowView else {
			let shadow = _UIShadowView(frame: bounds)
			shadow.isUserInteractionEnabled = false
			shadow.backgroundColor = .clear
			shadow.layer.masksToBounds = false
			shadow.layer.shouldRasterize = true
			shadow.layer.rasterizationScale = UIScreen.main.scale
			shadow.autoresizingMask = [
				.flexibleWidth,
				.flexibleHeight
			]
			objc_setAssociatedObject(self, &Associated.shadowViewKey, shadow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return shadow
		}
		return shadow
	}
	
	
	/// 为视图添加圆角和阴影 | 只在frame确定的时候才能调用此方法
	/// - Parameters:
	///   - corners: 圆角效果施加的角
	///   - cornerRadius: 圆角大小
	///   - shadowColor: 阴影颜色: 不为空才添加阴影
	///   - shadowOffsetX: 阴影偏移X
	///   - shadowOffsetY: 阴影偏移Y
	///   - shadowRadius: 阴影大小
	///   - shadowOpacity: 阴影透明度
	///   - shadowExpansion: 阴影扩大值:大于零扩大; 小于零收缩; 0:默认值
	func roundCorners(corners: UIRectCorner = .allCorners,
					  cornerRadius: CGFloat = 0.0,
					  withShadowColor shadowColor: UIColor? = nil,
					  shadowOffset: (x: Double, y: Double) = (0, 0),
					  shadowRadius: CGFloat = 0,
					  shadowOpacity: Float = 0,
					  shadowExpansion: CGFloat = 0) {
		// 圆角
		var bezier = UIBezierPath(
			roundedRect: bounds,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width:cornerRadius, height:cornerRadius)
		)
		if cornerRadius > 0 {
			// 未设置阴影的时候尝试使用iOS 11的API设置圆角
			if #available(iOS 11.0, *), shadowColor == nil {
				// 这个方法在UITableViewCell外部调用时 Section的最后一个Cell不起作用,不清楚为啥
				layer.masksToBounds = true
				layer.cornerRadius = cornerRadius
				layer.maskedCorners = corners.caCornerMask
			} else {
				let shape = CAShapeLayer()
				shape.path = bezier.cgPath
				layer.mask = shape
			}
		} else {
            if #available(iOS 11.0, *), shadowColor == nil {
                // 这个方法在UITableViewCell外部调用时 Section的最后一个Cell不起作用,不清楚为啥
                layer.masksToBounds = false
                layer.cornerRadius = cornerRadius
                layer.maskedCorners = corners.caCornerMask
            } else {
                layer.mask = nil
            }
		}
		
		// 阴影
		if let shadowColor = shadowColor {
			// 调整阴影View的frame
			shadowView.frame = frame
			// 设置阴影属性
			shadowView.layer.shadowColor = shadowColor.cgColor
			shadowView.layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
			shadowView.layer.shadowRadius = shadowRadius
			shadowView.layer.shadowOpacity = shadowOpacity
			// 设置阴影形状
			if shadowExpansion != 0 {
				let insets = UIEdgeInsets(
					top: -shadowExpansion,
					left: -shadowExpansion,
					bottom: -shadowExpansion,
					right: -shadowExpansion
				)
				bezier = UIBezierPath(
					roundedRect: bounds.inset(by: insets),
					byRoundingCorners: corners,
					cornerRadii: CGSize(width:cornerRadius, height:cornerRadius)
				)
			}
			shadowView.layer.shadowPath = bezier.cgPath
			if let superView = superview {
				superView.insertSubview(shadowView, belowSubview: self)
			}
		}
	}
}
// MARK: - __________ SwiftUI __________
#if DEBUG
@available(iOS 13.0, *)
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
