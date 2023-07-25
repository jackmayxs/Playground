//
//  UIImageViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/30.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UIImageView {
	
	func setImageInsets(_ insets: UIEdgeInsets, and image: UIImage?) {
        self.image = image.flatMap { image in
            image.image(with: insets)
        }
	}
}
