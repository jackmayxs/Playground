//
//  ViewController.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/12.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: BaseViewController {

	@IBOutlet weak var b1: UIButton!
	@IBOutlet weak var b2: UIButton!
	@IBOutlet weak var b3: UIButton!
	private let segmentControl = UISegmentedControl()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 三个按钮直选中一个按钮 实现看起来有点危险
		do {
			let buttons = [b1, b2, b3].map { $0! }
			let selectedButton = Observable.from(
				buttons.map {
					button in button.rx.tap.map { button }
				}
			)
			.merge()
			
			for button in buttons {
				selectedButton.map { $0 == button }
					.bind(to: button.rx.isSelected)
					.disposed(by: disposeBag)
			}
		}
		
		// SegmentControl 绑定UIImageView
		do {
			segmentControl.rx.selectedSegmentIndex
				.compactMap { i -> UIImage? in
					UIImage(named: "\(i).jpg")
				}
				.asDriver(onErrorJustReturn: UIImage())
				.drive { image in
					
				}
				.disposed(by: disposeBag)
		}
	}
}

