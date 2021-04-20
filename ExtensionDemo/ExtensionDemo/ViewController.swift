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

