//
//  SwiftUIViewPreview.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/3/3.
//  Copyright © 2021 Choi. All rights reserved.
//

#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct UIViewPreview: PreviewProvider {

	// 参考链接:
	// https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/
	static var devices = [
//		"iPhone 12 mini",   // 360x780 | @3x
		"iPhone 11 Pro",    // 375x812 | @3x
//		"iPhone 12 Pro",    // 390x844 | @3x
//		"iPhone 12 Pro Max" // 428x926 | @3x
	]
	
	static var uiView: UIView {
		XView()
	}
	
	static var previews: some View {
		ForEach(devices, id: \.self) { deviceName in
			uiView.preview
				.background(Color.secondary)
				.previewDevice(deviceName.previewDevice)
				.previewDisplayName(deviceName)
		}
	}
}

class XView: UIView {
	
	let aLabel = UILabel.new { make in
		make.translatesAutoresizingMaskIntoConstraints = false
		make.font = .systemFont(ofSize: 12.0)
		make.lineBreakMode = .byCharWrapping
		make.textColor = .yellow
		make.numberOfLines = 0
		make.text = """
			Xcode 编译项目时间漫长曾困扰多少 iOS 开发者。很多时候我们只是修改了一点 UI 相关的代码，想要看到效果我们就必须 重新 build 项目，即使 Xcode 有增量编译的优化，还是需要我们等待。这一次伴随着 SwiftUI 的到来，Xcode 也终于支持 Hot Reload 了！！！
			Xcode 11 支持在编辑器中显示用户界面的预览，我们可以在左侧编写代码，右侧预览界面实时刷新，无需重新运行项目我们就可以看到新的呈现了。
		"""
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(aLabel)
		updateConstraints()
	}
	
	override func updateConstraints() {
		let constraints: [NSLayoutConstraint] = [
			aLabel.topAnchor.constraint(equalTo: topAnchor),
			aLabel.leftAnchor.constraint(equalTo: leftAnchor),
			aLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			aLabel.rightAnchor.constraint(equalTo: rightAnchor)
		]
		NSLayoutConstraint.activate(constraints)
		super.updateConstraints()
	}
	
	required init?(coder: NSCoder) { nil }
}


//@available(iOS 13.0, *)
//struct UIViewControllerPreview: PreviewProvider {
//
//	static var previews: some View {
//		blankController.preview
//	}
//	static var blankController: UIViewController {
//		UIStoryboard(name: "Main", bundle: nil)
//			.instantiateViewController(identifier: "BlankViewController")
//	}
//}

extension String {
	var previewDevice: PreviewDevice {
		PreviewDevice(rawValue: self)
	}
}
#endif
