//
//  TouchesDelayedScrollView.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/2/18.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

final class TouchesDelayedScrollView: UIScrollView {
	
	/// 重写此方法, 可延迟子视图中点击事件, 避免滑动和点击事件冲突
	override func touchesShouldCancel(in view: UIView) -> Bool {
		if view.isKind(of: UIControl.self) {
			return true
		}
		return super.touchesShouldCancel(in: view)
	}
}
