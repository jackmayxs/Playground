//
//  SizeFixedView.swift
//  
//
//  Created by Choi on 2021/9/27.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

final class SizeFixedView: UIView {
	
    var fixedSize = CGSize.zero {
        willSet {
            invalidateIntrinsicContentSize()
        }
    }
	init(_ fixedSize: CGSize) {
		self.fixedSize = fixedSize
		super.init(frame: CGRect(origin: .zero, size: fixedSize))
	}
	
	override init(frame: CGRect) {
		self.fixedSize = frame.size
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override var intrinsicContentSize: CGSize {
		fixedSize
	}
}
