//
//  BaseViewController.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/31.
//  Copyright © 2022 Choi. All rights reserved.
//

import UIKit
import Jelly
import QMUIKit

final class ControllerPresentor {
    private var animator: Jelly.Animator?
    weak var presentingController: UIViewController?
    
    init(presentingController: UIViewController) {
        self.presentingController = presentingController
    }
    
    func slideIn(_ controller: UIViewController) {
        let presentation = CoverPresentation(
            directionShow: .bottom,
            directionDismiss: .bottom,
            uiConfiguration: PresentationUIConfiguration(
                cornerRadius: 20,
                backgroundStyle: .dimmed(alpha: 0.5),
                isTapBackgroundToDismissEnabled: true,
                corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            ),
            size: PresentationSize(
                width: .custom(value: controller.preferredContentSize.width),
                height: .custom(value: controller.preferredContentSize.height)
            ),
            alignment: PresentationAlignment(vertical: .bottom, horizontal: .center),
            marginGuards: .zero
        )
        animator = Animator(presentation: presentation)
        animator?.prepare(presentedViewController: controller)
        presentingController?.present(controller, animated: true)
    }
}

protocol ViewControllerConfiguration: UIViewController {

	/// 默认标题
	var defaultTitle: String? { get }
	
	/// 大标题导航栏
	var preferLargeTitles: Bool { get }
	
	/// 控制器配置 | 调用时机: viewDidLoad
	func configure()
	
	/// 配置导航条目 | 调用时机: viewDidLoad -> configure
	func configureNavigationItem(_ navigationItem: UINavigationItem)
	
	/// 配置导航栏样式 | 调用时机: viewWillAppear
	/// - Parameter navigationController: 导航控制器
	func configureNavigationController(_ navigationController: UINavigationController)
}

class BaseViewController<MainView: UIBaseView, ViewModel: ViewModelType>: UIViewController, UIGestureRecognizerDelegate, ViewControllerConfiguration {
	
    lazy var presentor = ControllerPresentor(presentingController: self)
    
    lazy var mainView = MainView()
    lazy var viewModel = ViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTargets()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		/// 配置导航控制器
		if let navigationController = navigationController {
			configureNavigationController(navigationController)
		}
        
        configureNavigationItem(navigationItem)
	}
    
    /// 默认标题
    var defaultTitle: String? { .none }
    
    /// 大标题导航栏
    var preferLargeTitles: Bool { false }
    
    /// 控制器配置 | 调用时机: viewDidLoad
    func configure() {
        if navigationController?.viewControllers.isNotEmpty ?? false {
            /// 导航控制器压栈时隐藏TabBar
            hidesBottomBarWhenPushed = true
        }
        /// 配置标题
        if title == .none, let defaultTitle = defaultTitle {
            title = defaultTitle
        }
    }
    
    /// 配置导航条目 | 调用时机: viewDidLoad -> configure
    func configureNavigationItem(_ navigationItem: UINavigationItem) {
        navigationItem.largeTitleDisplayMode = preferLargeTitles ? .automatic : .never
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(
                    image: R.image.arrowBack()?.withRenderingMode(.alwaysOriginal),
                    style: .plain,
                    target: self,
                    action: #selector(leftBarButtonItemTriggered)
                )
            } else if navigationController.viewControllers.count == 1 && presentingViewController != nil {
                navigationItem.leftBarButtonItem = UIBarButtonItem(
                    image: R.image.arrowBack()?.withRenderingMode(.alwaysOriginal),
                    style: .plain,
                    target: self,
                    action: #selector(leftBarButtonItemTriggered)
                )
            }
        }
    }
    
    /// 配置导航栏样式 | 调用时机: viewWillAppear
    /// - Parameter navigationController: 导航控制器
    func configureNavigationController(_ navigationController: UINavigationController) {
        
        /// 重新开启右滑返回
        navigationController.interactivePopGestureRecognizer?.delegate = self
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        let navigationBar = navigationController.navigationBar
        /// 导航栏会根据navigationItem.largeTitleDisplayMode显示大标题样式
        navigationBar.prefersLargeTitles = true
        
        if #available(iOS 13, *) {
            /// 配置样式
            let navBarAppearance = UINavigationBarAppearance(idiom: .phone)
            configureNavigationBarAppearance(navBarAppearance)
            
            /// 配置导航按钮样式
            let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
            barButtonItemAppearance.normal.titleTextAttributes = [:]
            barButtonItemAppearance.highlighted.titleTextAttributes = [:]
            barButtonItemAppearance.disabled.titleTextAttributes = [:]
            
            navBarAppearance.buttonAppearance = barButtonItemAppearance
            navBarAppearance.backButtonAppearance = barButtonItemAppearance
            navBarAppearance.doneButtonAppearance = barButtonItemAppearance
            
            /// 配置导航栏
            /// Represents a navigation bar in regular height without a large title.
            /// 其他两个属性使用这个当做默认值
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
            func globalConfigure() {
                let appearance = UINavigationBar.appearance()
                appearance.standardAppearance = navBarAppearance
                appearance.compactAppearance = navBarAppearance
                appearance.scrollEdgeAppearance = navBarAppearance
            }
        } else {
            configureNavigationBar(navigationBar)
        }
    }
    
    @available(iOS 13, *)
    func configureNavigationBarAppearance(_ barAppearance: UINavigationBarAppearance) {
        barAppearance.configureWithDefaultBackground() /// 毛玻璃效果(默认)
        //barAppearance.configureWithOpaqueBackground() /// 不透明
        //barAppearance.configureWithTransparentBackground() /// 全透明
        /// 隐藏分割线
        barAppearance.shadowColor = nil
        /// 设置返回按钮图片
        barAppearance.setBackIndicatorImage(nil, transitionMaskImage: nil)
        /// This will result in true color, just like when you set barTintColor with isTranslucent = false.
        //barAppearance.backgroundColor = .white
        //barAppearance.titlePositionAdjustment
        barAppearance.largeTitleTextAttributes = [
            :
        ]
        barAppearance.titleTextAttributes = [
            :
        ]
        //barAppearance.backgroundImage
        //barAppearance.backgroundEffect
        //barAppearance.backgroundImageContentMode
    }
    
    func configureNavigationBar(_ navigationBar: UINavigationBar) {
        lazy var emptyImage = UIImage()
        /// 设置返回按钮图片
        navigationBar.backIndicatorImage = nil
        /// The image used as a mask for content during push and pop transitions.
        navigationBar.backIndicatorTransitionMaskImage = nil
        /// 导航栏全透明
        navigationBar.setBackgroundImage(emptyImage, for: .default)
        navigationBar.shadowImage = emptyImage
        navigationBar.isTranslucent = true
        func transparentBarGlobally() {
            let barAppearance = UINavigationBar.appearance()
            barAppearance.setBackgroundImage(emptyImage, for: .default)
            barAppearance.shadowImage = emptyImage
            barAppearance.isTranslucent = true
        }
    }
    
    
    /// 添加事件
    /// 调用时机:viewDidload
    func prepareTargets() {
        
    }
    
    @objc func leftBarButtonItemTriggered() {
        escape(animated: true)
    }
    
    @objc func escape(animated: Bool = true) {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                goBack(animated: animated)
            } else {
                close(animated: animated)
            }
        } else {
            dismiss(animated: animated)
        }
    }
    
    @objc func close(animated: Bool = true, completion: SimpleCallback? = nil) {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: animated)
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }
    
    @objc func goBack(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}

extension BaseViewController {
    
    func popError(_ error: Error) {
        popToast(error.localizedDescription)
    }
    
    func popToast(_ message: String?) {
        let tips = QMUITips.createTips(to: view)
        let animator = QMUIToastAnimator(toastView: tips)
        tips.toastAnimator = animator
        tips.showInfo(message, hideAfterDelay: 2.0)
    }
}
