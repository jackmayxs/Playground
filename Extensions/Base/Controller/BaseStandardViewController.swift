//
//  BaseStandardViewController.swift
//
//  Created by Choi on 2022/8/18.
//

import UIKit
import RxSwift
import RxCocoa

class BaseStandardViewController<MainView: ViewModelConfigurableView>: BaseViewController {
    
    lazy var mainView = MainView()
    
    lazy var viewModel = MainView.ViewModel()
    
    override var defaultMainView: UIView? {
        mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setupViewModel(viewModel)
    }
}
