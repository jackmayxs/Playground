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
import Photos
import PhotosUI
import RxSwift
import RxCocoa

// MARK: - 控制器Presentor
struct ControllerPresentor {

    weak var presentingController: UIViewController!
    
    init(presentingController: UIViewController) {
        self.presentingController = presentingController
    }
    
    func fadeIn(_ controller: PresentedControllerType, tapBackgroundToDismissEnabled: Bool = true) {
        let fade = FadePresentation(
            size: controller.preferredContentSize.presentationSize,
            ui: PresentationUIConfiguration(
                cornerRadius: 6,
                backgroundStyle: .dimmed(alpha: 0.7),
                isTapBackgroundToDismissEnabled: tapBackgroundToDismissEnabled,
                corners: .allCorners
            )
        )
        let animator = Animator(presentation: fade)
        controller.prepareAnimator(animator)
        presentingController.present(controller, animated: true)
    }
    
    func popDialog(@SingleValueBuilder<PresentedControllerType> _ controllerBuilder: () -> PresentedControllerType) {
        let controller = controllerBuilder()
        popDialog(controller)
    }
    
    func popDialog(_ controller: PresentedControllerType) {
        let cover = CoverPresentation(
            directionShow: .left,
            directionDismiss: .right,
            uiConfiguration: PresentationUIConfiguration(
                cornerRadius: 6,
                backgroundStyle: .dimmed(alpha: 0.7),
                isTapBackgroundToDismissEnabled: true,
                corners: .allCorners
            ),
            size: controller.preferredContentSize.presentationSize,
            alignment: PresentationAlignment(vertical: .center, horizontal: .center),
            timing: PresentationTiming(duration: .normal, presentationCurve: .easeIn, dismissCurve: .easeOut)
        )
        let animator = Animator(presentation: cover)
        controller.prepareAnimator(animator)
        presentingController.present(controller, animated: true)
    }
    
    func slideIn(@SingleValueBuilder<PresentedControllerType> _ controllerBuilder: () -> PresentedControllerType) {
        let controller = controllerBuilder()
        slideIn(controller)
    }
    
    func slideIn(_ controller: PresentedControllerType) {
        let presentation = CoverPresentation(
            directionShow: .bottom,
            directionDismiss: .bottom,
            uiConfiguration: PresentationUIConfiguration(
                cornerRadius: 20,
                backgroundStyle: .dimmed(alpha: 0.7),
                isTapBackgroundToDismissEnabled: true,
                corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            ),
            size: controller.preferredContentSize.presentationSize,
            alignment: PresentationAlignment(vertical: .bottom, horizontal: .center),
            timing: PresentationTiming(duration: .normal, presentationCurve: .easeIn, dismissCurve: .easeOut)
        )
        let animator = Animator(presentation: presentation)
        controller.prepareAnimator(animator)
        presentingController.present(controller, animated: true)
    }
}

// MARK: - 控制器配置协议
protocol ViewControllerConfiguration: UIViewController {

	/// 默认标题
	var defaultTitle: String? { get }
	
	/// 大标题导航栏
	var preferLargeTitles: Bool { get }
	
	/// 控制器配置 | 调用时机: init
	func initialConfigure()
	
	/// 配置导航条目 | 调用时机: viewWillAppear
	func configureNavigationItem(_ navigationItem: UINavigationItem)
	
	/// 配置导航栏样式 | 调用时机: viewWillAppear
	/// - Parameter navigationController: 导航控制器
	func configureNavigationController(_ navigationController: UINavigationController)
}

// MARK: - 基类控制器
class BaseViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ViewControllerConfiguration, ErrorTracker, ActivityTracker {
	
    lazy var presentor = ControllerPresentor(presentingController: self)
    
    lazy var updateNotifier = PublishSubject<Any>()
    
    var targetImageSize: CGSize?
    
    private(set) lazy var backBarButtonItem = UIBarButtonItem(
        image: rImage.backArrowDark.original,
        style: .plain,
        target: self,
        action: #selector(leftBarButtonItemTriggered))
    
    private(set) lazy var closeBarButtonItem = UIBarButtonItem(
        image: rImage.clear14P.original,
        style: .plain,
        target: self,
        action: #selector(leftBarButtonItemTriggered))
    
    init() {
        super.init(nibName: nil, bundle: nil)
        initialConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialConfigure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// view loaded 之后的配置
        afterViewLoadedConfigure()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		/// 配置导航控制器
		if let navigationController = navigationController {
			configureNavigationController(navigationController)
		}
        
        configureNavigationItem(navigationItem)
	}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    /// 默认标题
    var defaultTitle: String? { .none }
    
    /// 大标题导航栏
    var preferLargeTitles: Bool { false }
    
    /// 是否显示导航栏
    var doHideNavigationBar: Bool { false }
    
    /// 控制器配置 | 调用时机: init
    func initialConfigure() {
        
        /// 导航控制器压栈时默认隐藏TabBar, 首页的几个RootController单独设置此属性为false
        /// 注: 此属性只有在控制器放入Navigation Stack之前设置才有效
        hidesBottomBarWhenPushed = true
    }
    
    /// viewDidLoad之后的配置 | 调用时机: viewDidLoad
    func afterViewLoadedConfigure() {
        /// 配置标题
        if title == .none, let defaultTitle = defaultTitle {
            title = defaultTitle
        }
        
        /// 配置Targets
        prepareTargets()
    }
    
    /// 配置导航条目 | 调用时机: viewWillAppear
    func configureNavigationItem(_ navigationItem: UINavigationItem) {
        navigationItem.largeTitleDisplayMode = preferLargeTitles ? .automatic : .never
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = backBarButtonItem
            } else if navigationController.viewControllers.count == 1 && presentingViewController != nil {
                navigationItem.leftBarButtonItem = closeBarButtonItem
            }
        }
    }
    
    /// 配置导航栏样式 | 调用时机: viewWillAppear
    /// - Parameter navigationController: 导航控制器
    func configureNavigationController(_ navigationController: UINavigationController) {
        
        /// 控制导航栏是否显示
        navigationController.setNavigationBarHidden(doHideNavigationBar, animated: true)
        
        /// 重新开启右滑返回
//        navigationController.interactivePopGestureRecognizer?.delegate = self
//        navigationController.interactivePopGestureRecognizer?.isEnabled = true
//        navigationController.delegate = self
        
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
    /// 调用时机: viewDidload -> afterViewLoadedConfigure
    func prepareTargets() {}
    
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
    
    func didGetImages(_ imageItems: [ImageItem]) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        /// 原始图片
        guard var image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        /// 编辑过的图片
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        }
        
        if let preferredImageSize = targetImageSize {
            if let resized = image.qmui_imageResized(inLimitedSize: preferredImageSize, resizingMode: .scaleAspectFit, scale: UIScreen.main.scale) {
                image = resized
            }
        }
        var imageItem = ImageItem(image: image)
        if let imageURL = info[.imageURL] as? URL {
            imageItem.imageURL = imageURL
        }
        didGetImages([imageItem])
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func trackError(_ error: Error?) {
        guard let error else { return }
        view.popFailToast(error.localizedDescription)
    }
    
    func trackActivity(_ isProcessing: Bool) {
        if isProcessing {
            view.makeToastActivity(.center)
        } else {
            view.hideToastActivity()
        }
    }
    
    override func forceEnableInteractivePopGestureRecognizer() -> Bool {
        true
    }
}

extension BaseViewController {
    
    func doneUpdate<T>(_ type: T.Type) -> Observable<T> {
        doneUpdate.as(type)
    }
    
    var doneUpdate: Observable<Any> {
        updateNotifier.take(1)
    }
    
    func popToast(_ message: String?) {
        let tips = QMUITips.createTips(to: view)
        let animator = QMUIToastAnimator(toastView: tips)
        tips.toastAnimator = animator
        tips.showInfo(message, hideAfterDelay: 2.0)
    }
    
    func fetchPhotos(count: Int = 1, targetImageSize: CGSize? = nil, allowsEditing: Bool = false) {
        self.targetImageSize = targetImageSize
        let sheet = ZKActionSheetController {
            ZKAction(title: localized.相册~) {
                [unowned self] in getPhotos(count: count, from: .photoLibrary, allowsEditing: allowsEditing)
            }
            ZKAction(title: localized.拍照~) {
                [unowned self] in getPhotos(count: 1, from: .camera, allowsEditing: allowsEditing)
            }
        }
        presentor.slideIn(sheet)
    }
    
    private func getPhotos(count: Int, from source: UIImagePickerController.SourceType, allowsEditing: Bool = false) {
        
        /// 检查图片源是否可用
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            trackError("Not supported source type.")
            return
        }
        
        /// 拍照 | 旧版图片选择控制器
        let pickPhotoFrom: (UIImagePickerController.SourceType) -> Void = {
            [unowned self] imageSource in
            let picker = UIImagePickerController()
            picker.sourceType = imageSource
            picker.allowsEditing = allowsEditing
            picker.delegate = self
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
        }
        
        /// 显示图片选择器
        let showPickerController = {
            [unowned self] in
            if #available(iOS 14, *) {
                let photoLibrary = PHPhotoLibrary.shared()
                var config = PHPickerConfiguration(photoLibrary: photoLibrary)
                config.filter = .images
                config.selectionLimit = count
                config.preferredAssetRepresentationMode = .automatic
                
                let picker = PHPickerViewController(configuration: config)
                picker.modalPresentationStyle = .fullScreen
                picker.delegate = self
                self.present(picker, animated: true)
            } else {
                pickPhotoFrom(source)
            }
        }
        
        switch source {
        case .camera:
            rx.disposeBag.insert {
                AVAuthorizationStatus.checkValidCameraStatus
                    .trackError(self)
                    .then(blockByError: true) { _ in
                        pickPhotoFrom(source)
                    }
            }
        case .photoLibrary, .savedPhotosAlbum:
            rx.disposeBag.insert {
                PHPhotoLibrary.chekValidAuthorizationStatus
                    .trackError(self)
                    .then(blockByError: true, sink(showPickerController))

            }
        @unknown default:
            break
        }
    }
}

extension BaseViewController: PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        guard results.isNotEmpty else {
            DispatchQueue.main.async {
                picker.dismiss(animated: true)
            }
            return
        }
        DispatchQueue.main.async {
            QMUITips.showLoading("正在处理", in: picker.view)
        }
        var imageURLs: [URL] = []
        var precessedImage = 0
        func doneProcess() {
            precessedImage += 1
            if precessedImage == results.count {
                /// 主线程调用
                DispatchQueue.main.async {
                    /// 隐藏提示
                    QMUITips.hideAllTips(in: picker.view)
                    let items = imageURLs.map { url in
                        ImageItem(imageURL: url)
                    }
                    /// 传回图片
                    self.didGetImages(items)
                    picker.dismiss(animated: true)
                }
            }
        }
        
        DispatchQueue.global().async {
            
            let identifiers = results.compactMap(\.assetIdentifier)
            let finalResult: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            finalResult.enumerateObjects { asset, index, tag in
                let resources = PHAssetResource.assetResources(for: asset)
                if let first = resources.first, let url = first.value(forKey: "privateFileURL") as? URL {
                    imageURLs.append(url)
                }
                doneProcess()
            }
            
//            for result in results {
//                let itemProvider = result.itemProvider
//                /// In this code, the order of the UTType check is deliberate(故意的).
//                /// A live photo can be supplied in a simple UIImage representation, so if we test for images before live photos, we won’t learn that the result is a live photo.
//                if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
//                    // it's a video
//                } else if itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
//                    // it's a live photo
//                } else if itemProvider.canLoadObject(ofClass: UIImage.self) {
//                    // it's a photo
//                    let commonImageTypes: [UTType] = [.jpeg, .png, .heic, .heif]
//                    var iterator = commonImageTypes.makeIterator()
//                    var notFound = true
//                    while let imageType = iterator.next(), notFound {
//                        let semaphore = DispatchSemaphore(value: 0)
//                        itemProvider.loadFileRepresentation(forTypeIdentifier: imageType.identifier) { url, error in
//                            dprint("haha", url.asAny)
//                        }
//                        itemProvider.loadInPlaceFileRepresentation(forTypeIdentifier: imageType.identifier) { url, flag, error in
//                            if let validURL = url {
//                                imageURLs.append(validURL)
//                                notFound = false
//                                doneProcess()
//                            } else {
//                                dprint("无法处理")
//                            }
//                            semaphore.signal()
//                        }
//                        semaphore.wait()
//                    }
//                }
//            }
            
            
            
            
            
            
            
            
        }
    }
}
