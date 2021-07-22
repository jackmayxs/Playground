//
//  ShadowPlayground.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/7/23.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

final class ShadowSuperView: UIView {
	private let view = ShadowPlayground()
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		addSubview(view)
		view.backgroundColor = .green
		view.sizeToFit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		addSubview(view)
		view.backgroundColor = .green
		view.sizeToFit()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		view.bounds.size = 200
		view.center = center
		view.roundCorners(corners: [.topLeft, .bottomRight], cornerRadius: 20, withShadowColor: .red, shadowRadius: 50, shadowOpacity: 1)
	}
}

final class ShadowPlayground: UIView {

	override var frame: CGRect {
		get { super.frame }
		set {
			super.frame = newValue
//			// 普通方式:加圆角加阴影
//			layer.masksToBounds = false // 用于处理带有Sublayer的情况. 比如UIImageView
//			layer.cornerRadius = 50.0
//			layer.maskedCorners = [
//				.layerMaxXMaxYCorner,
//				.layerMaxXMinYCorner
//			]
//
//			layer.borderColor = UIColor.yellow.cgColor
//			layer.borderWidth = 5.0
//
//			layer.shadowColor = UIColor.blue.cgColor
//			layer.shadowOffset = CGSize(width: 20, height: 20)
//			layer.shadowRadius = 15.0
//			layer.shadowOpacity = 0.8
			
			
//			// 贝塞尔曲线添加圆角
//			let bezier = UIBezierPath(
//				roundedRect: bounds,
//				byRoundingCorners: .allCorners,
//				cornerRadii: 50
//			)
//			let shape = CAShapeLayer()
//			shape.path = bezier.cgPath
//			layer.mask = shape
			
//			// 贝塞尔曲线添加阴影
//			let bezier = UIBezierPath(
//				roundedRect: bounds,
//				byRoundingCorners: [.allCorners],
//				cornerRadii: 0
//			)
//			layer.shadowColor = UIColor.blue.cgColor
//			layer.shadowOffset = CGSize(width: 75, height: 75)
//			layer.shadowRadius = 3
//			layer.shadowOpacity = 1
//
//			layer.shouldRasterize = true
//			layer.rasterizationScale = UIScreen.main.scale
//			layer.shadowPath = bezier.cgPath
			
//			// 添加垂直阴影
//			let shadowSize: CGFloat = 20
//			let shadowDistance: CGFloat = 20
//			let contactRect = CGRect(x: -shadowSize, y: frame.height - (shadowSize * 0.4) + shadowDistance, width: frame.width + shadowSize * 2, height: shadowSize)
//			layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
//			layer.shadowRadius = 5
//			layer.shadowOpacity = 0.4
			
//			// 添加立体阴影
//			let shadowWidth: CGFloat = 1.2
//			let shadowHeight: CGFloat = 0.5
//			let shadowOffsetX: CGFloat = -50
//			let shadowRadius: CGFloat = 5
//
//			let shadowPath = UIBezierPath()
//			shadowPath.move(to: CGPoint(x: shadowRadius / 2, y: height - shadowRadius / 2))
//			shadowPath.addLine(to: CGPoint(x: width, y: height - shadowRadius / 2))
//			shadowPath.addLine(to: CGPoint(x: width * shadowWidth + shadowOffsetX, y: height + (height * shadowHeight)))
//			shadowPath.addLine(to: CGPoint(x: width * -(shadowWidth - 1) + shadowOffsetX, y: height + (height * shadowHeight)))
//			layer.shadowPath = shadowPath.cgPath
//			layer.shadowRadius = shadowRadius
//			layer.shadowOffset = .zero
//			layer.shadowOpacity = 0.2
			
//			// 扁平的长阴影
//			layer.shadowRadius = 0
//			layer.shadowOffset = .zero
//			layer.shadowOpacity = 0.2
//
//			// how far the bottom of the shadow should be offset
//			let shadowOffsetX: CGFloat = 2000
//			let shadowPath = UIBezierPath()
//			shadowPath.move(to: CGPoint(x: 0, y: height))
//			shadowPath.addLine(to: CGPoint(x: width, y: height))
//
//			// make the bottom of the shadow finish a long way away, and pushed by our X offset
//			shadowPath.addLine(to: CGPoint(x: width + shadowOffsetX, y: 2000))
//			shadowPath.addLine(to: CGPoint(x: shadowOffsetX, y: 2000))
//			layer.shadowPath = shadowPath.cgPath
			
//			// 弯曲的阴影
//			let shadowRadius: CGFloat = 5
//			layer.shadowRadius = 5
//			layer.shadowOffset = CGSize(width: 0, height: 10)
//			layer.shadowOpacity = 0.5
//
//			// how strong to make the curling effect
//			let curveAmount: CGFloat = 20
//			let shadowPath = UIBezierPath()
//
//			// the top left and right edges match our view, indented by the shadow radius
//			shadowPath.move(to: CGPoint(x: shadowRadius, y: 0))
//			shadowPath.addLine(to: CGPoint(x: width - shadowRadius, y: 0))
//
//			// the bottom-right edge of our shadow should overshoot by the size of our curve
//			shadowPath.addLine(to: CGPoint(x: width - shadowRadius, y: height + curveAmount))
//
//			// the bottom-left edge also overshoots by the size of our curve, but is added with a curve back up towards the view
//			shadowPath.addCurve(to: CGPoint(x: shadowRadius, y: height + curveAmount), controlPoint1: CGPoint(x: width, y: height - shadowRadius), controlPoint2: CGPoint(x: 0, y: height - shadowRadius))
//			layer.shadowPath = shadowPath.cgPath
			
//			// 加外边框
//			let edge: UIEdgeInsets = 20
//			let shadowPath = UIBezierPath(
//				roundedRect: bounds.inset(by: edge.reversed),
//				byRoundingCorners: [.topLeft, .topRight],
//				cornerRadii: 20
//			)
//
//			layer.shadowPath = shadowPath.cgPath
//			layer.shadowOffset = .zero
//			layer.shadowRadius = 0
//			layer.shadowOpacity = 1
//			layer.shadowColor = UIColor.red.cgColor
		}
	}
}
