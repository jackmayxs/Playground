//
//  InsetsLabel.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/11/4.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

class InsetsLabel: UILabel {
	
	var textEdgeInsets: UIEdgeInsets = .zero {
		didSet {
			setNeedsDisplay()
			invalidateIntrinsicContentSize()
		}
	}
	
	override func textRect(forBounds bounds: CGRect,
						   limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		super.textRect(forBounds: bounds.inset(by: textEdgeInsets),
					   limitedToNumberOfLines: numberOfLines)
			.inset(by: textEdgeInsets.reverse)
	}
	
	override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: textEdgeInsets))
	}
}
