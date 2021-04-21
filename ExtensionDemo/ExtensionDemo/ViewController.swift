//
//  ViewController.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/7/22.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet var buttonSizeConstraints: [NSLayoutConstraint]!
	@IBOutlet weak var axisSegment: UISegmentedControl!
	@IBOutlet weak var topButton: UIButton!
	@IBOutlet weak var spacingTF: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		topButton.titleLabel?.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.3)
		
		// 创建文本标签
		let label = UILabel()
		label.text = "正在加载中......"
		label.textColor = .white
		label.textAlignment = .center
		label.frame = CGRect(x: (Size.screenWidth * 0.5 - 100), y: 0, width: 200, height: 50)
		
		// 创建波浪视图
		let waveView = WaveView(frame: CGRect(x: 0, y: 150, width: Size.screenWidth, height: 130))
		waveView.backgroundColor = .lightGray
		// 波浪动画回调
		waveView.closure = { centerY in
			// 同步更新文本标签的y坐标
			label.frame.origin.y = waveView.frame.height + centerY - 55
		}
		
		// 添加两个视图
		self.view.addSubview(waveView)
		self.view.addSubview(label)
		
		// 开始播放波浪动画
		waveView.startWave()
	}
	@IBAction func horizontalChanged(_ sender: UISegmentedControl) {
		topButton.setImageTitleAxis()
		axisSegment.selectedSegmentIndex = 1
		switch sender.selectedSegmentIndex {
			case 0: topButton.contentHorizontalAlignment = .center
			case 1: topButton.contentHorizontalAlignment = .left
			case 2: topButton.contentHorizontalAlignment = .right
			case 3: topButton.contentHorizontalAlignment = .fill
			case 4: topButton.contentHorizontalAlignment = .leading
			case 5: topButton.contentHorizontalAlignment = .trailing
			default:
				return
		}
		UIView.animate(withDuration: 1.0) {
			self.view.layoutIfNeeded()
		}
	}
	@IBAction func verticalChanged(_ sender: UISegmentedControl) {
		topButton.setImageTitleAxis()
		axisSegment.selectedSegmentIndex = 1
		switch sender.selectedSegmentIndex {
			case 0: topButton.contentVerticalAlignment = .center
			case 1: topButton.contentVerticalAlignment = .top
			case 2: topButton.contentVerticalAlignment = .bottom
			case 3: topButton.contentVerticalAlignment = .fill
			default:
				return
		}
		topButton.setNeedsLayout()
		UIView.animate(withDuration: 1.0) {
			self.view.layoutIfNeeded()
		}
	}
	@IBAction func buttonStyleChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
			case 0:
				topButton.setTitle("Button", for: .normal)
				topButton.setImage(#imageLiteral(resourceName: "hei"), for: .normal)
			case 1:
				topButton.setTitle(nil, for: .normal)
				topButton.setImage(#imageLiteral(resourceName: "hei"), for: .normal)
			case 2:
				topButton.setTitle("Button", for: .normal)
				topButton.setImage(nil, for: .normal)
			default:
				break
		}
	}
	@IBAction func imageTitleStyleChanged(_ sender: UISegmentedControl) {
		let spacing = CGFloat(Double(spacingTF.text ?? "") ?? 0)
		switch sender.selectedSegmentIndex {
			case 0: topButton.setImageTitleAxis(.down, spacing: spacing)
			case 1: topButton.setImageTitleAxis(.right, spacing: spacing)
			case 2: topButton.setImageTitleAxis(.up, spacing: spacing)
			case 3: topButton.setImageTitleAxis(.left, spacing: spacing)
			default: break
		}
		UIView.animate(withDuration: 1.0) {
			self.view.layoutIfNeeded()
		}
	}
	@IBAction func resetTopButton(_ sender: UIButton) {
		topButton.setImageTitleAxis(.right)
	}
	@IBAction func toggleFixedSize(_ sender: UIButton) {
		
		buttonSizeConstraints.forEach { c in
			c.isActive.toggle()
		}
		UIView.animate(withDuration: 0.2) {
			self.view.layoutIfNeeded()
		}
	}
}
extension UIColor {
	
	//使用rgb方式生成自定义颜色
	convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat) {
		let red = r / 255.0
		let green = g / 255.0
		let blue = b / 255.0
		self.init(red: red, green: green, blue: blue, alpha: 1)
	}
	
	//使用rgba方式生成自定义颜色
	convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat) {
		let red = r / 255.0
		let green = g / 255.0
		let blue = b / 255.0
		self.init(red: red, green: green, blue: blue, alpha: a)
	}
}
class WaveView: UIView {
	// 波浪高度h
	var waveHeight: CGFloat = 20
	// 波浪宽度系数
	var waveRate: CGFloat = 0.01
	// 波浪移动速度
	var waveSpeed: CGFloat = 0.02
	// 真实波浪颜色
	var realWaveColor: UIColor = UIColor(55, 153, 249)
	// 阴影波浪颜色
//	var maskWaveColor: UIColor = UIColor(55, 153, 249, 0.3)
	var maskWaveColor: UIColor = UIColor.red
	// 波浪位置（默认是在下方）
	var waveOnBottom = false
	// 波浪移动回调
	var closure: ((_ centerY: CGFloat)->())?
	
	// 定时器
	private var displayLink: CADisplayLink?
	// 真实波浪
	private let realWaveLayer = CAShapeLayer()
	// 阴影波浪
	private let maskWaveLayer = CAShapeLayer()
	// 波浪的偏移量
	private var offset: CGFloat = 0
	
	// 视图初始化
	override init(frame: CGRect) {
		super.init(frame: frame)
		initWaveParame()
	}
	
	// 视图初始化
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initWaveParame()
	}
	
	// 组件初始化
	private func initWaveParame() {
		layer.addSublayer(maskWaveLayer)
		layer.addSublayer(realWaveLayer)
	}
	
	// 开始播放动画
	func startWave() {
		// 开启定时器
		displayLink = CADisplayLink(target: self, selector: #selector(self.wave))
		displayLink!.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
	}
	
	// 停止播放动画
	func endWave() {
		// 结束定时器
		displayLink!.invalidate()
		displayLink = nil
	}
	
	// 定时器响应（每一帧都会调用一次）
	@objc func wave() {
		// 波浪移动的关键：按照指定的速度偏移
		offset += waveSpeed

		// 起点y坐标（没有波浪的一侧）
		let startY = self.waveOnBottom ? 0 : frame.size.height
		
		let realPath = UIBezierPath()
		realPath.move(to: CGPoint(x: 0, y: startY))
		
		let maskPath = UIBezierPath()
		maskPath.move(to: CGPoint(x: 0, y: startY))
		
		var x = CGFloat(0)
		var y = CGFloat(0)
		while x <= bounds.size.width {
			// 波浪曲线
			y = waveHeight * sin(x * waveRate + offset)
			// 如果是下波浪还要加上视图高度
			let realY = y + (self.waveOnBottom ? frame.size.height : 0)
			let maskY = -y + (self.waveOnBottom ? frame.size.height : 0)
			
			realPath.addLine(to: CGPoint(x: x, y: realY))
			maskPath.addLine(to: CGPoint(x: x, y: maskY))
			
			// 增量越小，曲线越平滑
			x += 0.1
		}
		
		let midX = bounds.size.width * 0.5
		let midY = waveHeight * sin(midX * waveRate + offset)
		
		if let closureBack = closure {
			closureBack(midY)
		}
		// 回到起点对侧
		realPath.addLine(to: CGPoint(x: frame.size.width, y: startY))
		maskPath.addLine(to: CGPoint(x: frame.size.width, y: startY))
		
		// 闭合曲线
		maskPath.close()
		
		// 把封闭图形的路径赋值给CAShapeLayer
		maskWaveLayer.path = maskPath.cgPath
		maskWaveLayer.fillColor = maskWaveColor.cgColor
		
		realPath.close()
		realWaveLayer.path = realPath.cgPath
		realWaveLayer.fillColor = realWaveColor.cgColor
	}
}
