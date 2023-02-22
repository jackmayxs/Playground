//
//  BaseStandardViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/18.
//

import UIKit
import RxSwift
import RxCocoa

class BaseStandardViewController<MainView: UIBaseView, ViewModel: ViewModelType>: BaseViewController {
    
    lazy var mainView = MainView()
    
    lazy var viewModel = ViewModel()
    
    override var defaultMainView: UIView? {
        mainView
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
