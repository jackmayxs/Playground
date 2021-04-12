//
//  BaseViewController.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/12.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
	lazy var disposeBag = DisposeBag()
	
	deinit {
		print(String(describing: classForCoder), "deinit")
	}
}
