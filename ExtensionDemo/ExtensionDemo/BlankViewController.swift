//
//  BlankViewController.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/7/29.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

class BlankViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		[
			1.234,
			2.355,
			0.346,
			-1.234,
			-2.355,
			-0.346
		].forEach { number in
			print(number.signedR2)
		}
	}
	@IBAction func makeRoundCorners(_ sender: Any) {
		imageView.image = imageView.image?.roundImage
	}
}
