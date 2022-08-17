//
//  UIBaseView.swift
//  zeniko
//
//  Created by Choi on 2022/8/3.
//

import UIKit
import RxSwift
import RxCocoa
import QMUIKit
import Moya

protocol ViewModelType: SimpleInitializer {}

protocol ControllerBaseView: StandartLayoutLifeCycle {
    associatedtype ViewModel: ViewModelType
    func setupViewModel(_ viewModel: Self.ViewModel)
}

class BaseViewModel: ViewModelType, ReactiveCompatible {
    required init() {}
}

class PagableViewModel<Target: TargetType, Model: Codable>: BaseViewModel {
    
    var target: Target! { nil }
    
    var sendRequest: Single<[Model]> {
        Network.request(target, logLevel: .verbose).map(Array<Model>.self)
    }
}

class UIBaseView: UIView, ControllerBaseView, ErrorTracker {
    typealias ViewModel = BaseViewModel
    
    var defaultBackgroundColor: UIColor { .baseBlack }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    func prepare() {
        self.backgroundColor = defaultBackgroundColor
        prepareSubviews()
        prepareConstraints()
    }
    
    func prepareSubviews() {}
    
    func prepareConstraints() {}
    
    func setupViewModel(_ viewModel: BaseViewModel) {}
    
    func popError(_ error: Error) {
        QMUITips.showError(error.localizedDescription, in: self)
    }
}
