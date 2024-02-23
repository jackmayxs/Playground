//
//  UIBaseView.swift
//
//  Created by Choi on 2022/8/3.
//

import UIKit
import RxSwift
import RxCocoa
import QMUIKit
import Moya

// MARK: - 相关协议
protocol ViewModelType: SimpleInitializer {}

protocol PagableViewModelType: ViewModelType {
    associatedtype Model
    var delegate: PagableViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var items: [Model] { get set }
    func fetchMoreData()
    init(delegate: PagableViewModelDelegate)
}

protocol ViewControllerView {
    associatedtype ViewController: UIViewController
    var viewController: ViewController { get set }
}

protocol ViewModelConfigurable {
    associatedtype ViewModel: ViewModelType
    func setupViewModel(_ viewModel: ViewModel)
}

extension ViewModelConfigurable {
    func setupViewModel(_ viewModel: ViewModel) {}
}

protocol PagableViewModelDelegate: AnyObject {
    func itemsUpdated()
}

typealias ViewModelConfigurableView = ViewModelConfigurable & StandardLayoutLifeCycle

// MARK: - 基类
/// 使用NSObject子类实现ViewModel
/// 是为了某些情况下监听rx.deallocating通知, 以做一些逻辑处理
/// 而纯Swift的Class只能监听到rx.deallocated事件, 无法监听到rx.deallocating事件
/// 后来证明在VM里监听rx.deallocating没什么意义, 因为这时自身已经快销毁了, 很多属性都无效了
/// 但还是暂时用NSObjct的子类来实现吧, 以防万一
/// 而且有些协议只能由NSObject类实现
class BaseViewModel: NSObject, ViewModelType {
    
    override init() {
        super.init()
        didInitialize()
    }
    
    func didInitialize() {}
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
    
    /// 注意这里必须用convenience初始化方法, 否则某些情况下会循环调用didInitialize()方法!!!
    required convenience init(delegate: PagableViewModelDelegate) {
        self.init()
        self.delegate = delegate
    }
    
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
    
    var defaultBackgroundColor: UIColor? { baseViewBackgroundColor }
    
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

class UIBaseControllerView<ViewController: UIViewController>: UIBaseView, ViewControllerView {
    
    private weak var innerController: ViewController?
    
    var viewController: ViewController {
        get { innerController ?? neverController }
        set { innerController = newValue }
    }
    
    convenience init(controller: ViewController) {
        self.init(frame: .zero)
        attach(controller: controller)
    }
    
    @discardableResult func attach(controller: ViewController) -> Self {
        viewController = controller
        return self
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if innerController.isVoid, let retreiveController = qmui_viewController as? ViewController {
            innerController = retreiveController
        }
    }
    
    private var neverController: ViewController {
        fatalError("Should not happen! Check your logic.")
    }
}

// MARK: - UIView协议实现
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
