//
//  BaseStandardViewController.swift
//
//  Created by Choi on 2022/8/18.
//

import UIKit
import RxSwift
import RxCocoa

class BaseStandardViewController<MainView: ViewModelConfigurableView>: BaseViewController, ViewModelAccessible {
    
    lazy var mainView = makeMainView()
    
    lazy var viewModel = MainView.ViewModel()
    
    override var defaultMainView: UIView? {
        mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setupViewModel(viewModel)
    }
    
    /// Override point
    /// 子类可重写此方法使用自己定义的主视图初始化方法创建主视图
    /// 例如: UIControllerView需要使用init(controller: ViewController)方法创建主视图
    func makeMainView() -> MainView {
        MainView()
    }
}
