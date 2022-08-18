//
//  BaseStandardViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/18.
//

import UIKit

class BaseStandardViewController<MainView: UIBaseView, ViewModel: ViewModelType>: BaseViewController {
    
    lazy var mainView = MainView()
    
    lazy var viewModel = ViewModel()
    
    override func loadView() {
        view = mainView
    }
}
