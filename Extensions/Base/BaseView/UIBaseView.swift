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
protocol PagableViewModelType<Model>: ViewModelType {
    associatedtype Model
    var delegate: PagableViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var items: [Model] { get set }
    func fetchMoreData()
    init(delegate: PagableViewModelDelegate)
}

protocol ViewModelConfigurable<ViewModel> {
    associatedtype ViewModel: ViewModelType
    func setupViewModel(_ viewModel: ViewModel)
}

extension ViewModelConfigurable {
    func setupViewModel(_ viewModel: ViewModel) {}
}

typealias ControllerBaseView = ViewModelConfigurable & StandardLayoutLifeCycle

class BaseViewModel: ViewModelType, ReactiveCompatible {
    required init() {}
}

protocol PagableViewModelDelegate: AnyObject {
    func itemsUpdated()
}

class BasePagableViewModel<Model>: BaseViewModel, PagableViewModelType {
    var itemsPerPage = 50
    var page = 1
    
    weak var delegate: PagableViewModelDelegate? {
        didSet {
            /// 设置完代理之后主动调用一次更新方法
            delegate?.itemsUpdated()
        }
    }
    
    @Variable var items: [Model] = [] {
        didSet {
            delegate?.itemsUpdated()
        }
    }
    
    required init() {
        super.init()
        didInitialize()
    }
    
    /// 注意这里必须用convenience初始化方法, 否则某些情况下会循环调用didInitialize()方法!!!
    required convenience init(delegate: PagableViewModelDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func didInitialize() {}
    
    func fetchMoreData() {}
    
    var numberOfItems: Int { items.count }
    
    subscript (indexPath: IndexPath) -> Model {
        items[indexPath.row]
    }
    
    subscript (index: Int) -> Model {
        items[index]
    }
}

class PagableViewModel<Target: TargetType, Model: Codable>: BasePagableViewModel<Model> {

    var target: Target? { nil }
    
    override func didInitialize() {
        guard let validTarget = target else { return }
        rx.disposeBag.insert {
            Network.request(validTarget)
                .map(Array<Model>.self, atKeyPath: "data")
                .do(afterSuccess: rx.items.onNext)
                .subscribe()
        }
    }
}

class UIBaseView: UIView {
    
    var defaultBackgroundColor: UIColor { baseViewBackgroundColor }
    
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
}

extension UIView: ErrorTracker {
    
    func trackError(_ error: Error?, isFatal: Bool = true) {
        guard let error else { return }
        if isFatal {
            popFailToast(error.localizedDescription)
        } else {
            popToast(error.localizedDescription)
        }
    }
}
