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
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var spacing: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        [btn0, btn1, btn2, btn3].forEach { make in
            make?.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            make?.titleLabel?.backgroundColor = .red
        }
        
        btn0.adjustImageTitleStyle(.㊤㊦, spacing: 20)
        btn1.adjustImageTitleStyle(.㊧㊨, spacing: 20)
        btn2.adjustImageTitleStyle(.㊦㊤, spacing: 20)
        btn3.adjustImageTitleStyle(.㊨㊧, spacing: 20)
        
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
        let spacing = CGFloat(Double(self.spacing.text ?? "") ?? 0)
        switch sender.selectedSegmentIndex {
        case 0: topButton.adjustImageTitleStyle(.㊤㊦, spacing: spacing)
        case 1: topButton.adjustImageTitleStyle(.㊧㊨, spacing: spacing)
        case 2: topButton.adjustImageTitleStyle(.㊦㊤, spacing: spacing)
        case 3: topButton.adjustImageTitleStyle(.㊨㊧, spacing: spacing)
        default:
            break
        }
        UIView.animate(withDuration: 1) {
            self.topButton.layoutIfNeeded()
        }
    }
    @IBAction func resetTopButton(_ sender: UIButton) {
        topButton.adjustImageTitleStyle(.㊧㊨)
    }
}

