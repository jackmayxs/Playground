//
//  ViewController.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/7/22.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var topButton: UIButton!
	@IBOutlet weak var spacing: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		topButton.titleLabel?.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.2)
		topButton.imageView?.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.2)
	}
	@IBAction func horizontalChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
			case 0: topButton.contentHorizontalAlignment = .center
			case 1: topButton.contentHorizontalAlignment = .left
			case 2: topButton.contentHorizontalAlignment = .right
			case 3: topButton.contentHorizontalAlignment = .leading
			case 4: topButton.contentHorizontalAlignment = .trailing
			default:
				return
		}
		UIView.animate(withDuration: 1) {
			self.topButton.layoutIfNeeded()
		}
	}
	@IBAction func verticalChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
			case 0: topButton.contentVerticalAlignment = .center
			case 1: topButton.contentVerticalAlignment = .top
			case 2: topButton.contentVerticalAlignment = .bottom
			case 3: topButton.contentVerticalAlignment = .fill
			default:
				return
		}
		topButton.setNeedsLayout()
		UIView.animate(withDuration: 1) {
			self.topButton.layoutIfNeeded()
		}
	}
	@IBAction func buttonStyleChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
			case 0:
				topButton.setTitle("Button", for: .normal)
				topButton.setImage(UIImage(named: "icon"), for: .normal)
			case 1:
				topButton.setTitle(nil, for: .normal)
				topButton.setImage(UIImage(named: "icon"), for: .normal)
			case 2:
				topButton.setTitle("Button", for: .normal)
				topButton.setImage(nil, for: .normal)
			default:
				break
		}
	}
	@IBAction func imageTitleStyleChanged(_ sender: UISegmentedControl) {
		let gap = CGFloat(Double(self.spacing.text ?? "") ?? 0)
		switch sender.selectedSegmentIndex {
			case 0: topButton.setImageTitleAxis(.down, gap: gap)
			case 1: topButton.setImageTitleAxis(.right, gap: gap)
			case 2: topButton.setImageTitleAxis(.up, gap: gap)
			case 3: topButton.setImageTitleAxis(.left, gap: gap)
			default: break
		}
		UIView.animate(withDuration: 1) {
			self.topButton.layoutIfNeeded()
		}
	}
	@IBAction func resetTopButton(_ sender: UIButton) {
		topButton.setImageTitleAxis(.right)
	}
}

