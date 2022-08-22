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

protocol PagableViewModelDelegate: AnyObject {
    func gotItemsFromServer()
}

class PagableViewModel_: BaseViewModel {
    weak var delegate: PagableViewModelDelegate?
    var itemsPerPage = 50
    var page = 1
    var numberOfItems: Int { 0 }
    
    func fetchMoreData() {
        
    }
}

class PagableViewModel<Target: TargetType, Model: Codable>: PagableViewModel_ {

    var target: Target? { nil }
    
    @Variable var items: [Model] = [] {
        didSet {
            delegate?.gotItemsFromServer()
        }
    }
    
    override func fetchMoreData() {
        guard let validTarget = target else { return }
        rx.disposeBag.insert {
            Network.request(validTarget)
                .map([Model].self, atKeyPath: "data")
                .do(afterSuccess: rx.items.onNext)
                .subscribe()
        }
    }
    
    override var numberOfItems: Int { items.count }
    
    subscript (indexPath: IndexPath) -> Model {
        items[indexPath.row]
    }
}

class UIBaseView: UIView, ControllerBaseView {
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
}

extension UIView: ErrorTracker {
    
    func popError(_ error: Error) {
        QMUITips.showError(error.localizedDescription, in: self)
    }
}
