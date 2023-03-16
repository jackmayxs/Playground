//
//  BaseStandardViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/18.
//

import UIKit
import RxSwift
import RxCocoa

class BaseStandardViewController<MainView: ControllerBaseView>: BaseViewController {
    
    lazy var mainView = MainView()
    
    lazy var viewModel = MainView.ViewModel()
    
    override var defaultMainView: UIView? {
        mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setupViewModel(viewModel)
    }
    
    override func prepareTargets() {
        super.prepareTargets()
        rx.disposeBag.insert {
            UIApplication.shared.rx.latestResponderViewAndKeyboardPresentation
                .bindErrorIgnored {
                    [unowned self] responder, presentation in
                    presentation.adjustBoundsOfSuperview(mainView, firstResponder: responder)
                }
        }
    }
}
