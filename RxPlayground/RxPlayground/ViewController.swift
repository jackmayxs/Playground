//
//  ViewController.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/12.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class ViewController: BaseViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let b1 = UIButton()
		let b2 = UIButton()
		let b3 = UIButton()
		
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
			let segmentControl = UISegmentedControl()
			segmentControl.rx.selectedSegmentIndex
				.compactMap { i -> UIImage? in
					UIImage(named: "\(i).jpg")
				}
				.asDriver(onErrorJustReturn: UIImage())
				.drive { image in
					
				}
				.disposed(by: disposeBag)
		}
		
		do {
			let imgV = UIImageView()
			/// 拍照
			b1.rx.tap.flatMapLatest {
				UIImagePickerController.rx.createdWithParent(self, animated: true) { make in
					make.sourceType = .camera
					make.allowsEditing = false
				}
				.flatMap { $0.rx.didFinishPickingMediaWithInfo }
			}
			.map { info in
				info[.originalImage] as? UIImage
			}
			.bind(to: imgV.rx.image)
			.disposed(by: disposeBag)
			
			/// 选图片
			b2.rx.tap.flatMapLatest {
				UIImagePickerController.rx.createdWithParent(self, animated: true) { make in
					make.sourceType = .photoLibrary
					make.allowsEditing = false
				}
				.flatMap { $0.rx.didFinishPickingMediaWithInfo }
			}
			.map { info in
				info[.originalImage] as? UIImage
			}
			.bind(to: imgV.rx.image)
			.disposed(by: disposeBag)
			
			//“选择照片并裁剪”按钮点击
			b3.rx.tap.flatMapLatest {
				UIImagePickerController.rx.createdWithParent(self) { picker in
					picker.sourceType = .photoLibrary
					picker.allowsEditing = true
				}
				.flatMap { $0.rx.didFinishPickingMediaWithInfo }
			}
			.map { info in
				info[.editedImage] as? UIImage
			}
			.bind(to: imgV.rx.image)
			.disposed(by: disposeBag)
		}
		
		do {
			
		}
	}
}

