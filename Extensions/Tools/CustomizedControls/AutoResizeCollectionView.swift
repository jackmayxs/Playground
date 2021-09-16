//
//  AutoResizeCollectionView.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/9/16.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

class AutoResizeCollectionView: UICollectionView {
	override var contentSize: CGSize {
		get { super.contentSize }
		set {
			super.contentSize = newValue
			invalidateIntrinsicContentSize()
		}
	}
	override var intrinsicContentSize: CGSize { contentSize }
}
