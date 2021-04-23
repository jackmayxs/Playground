//
//  ImagePickingService.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/23.
//

import UIKit
import RxSwift
import RxCocoa

public typealias UIImagePickerControllerProtocols = UIImagePickerControllerDelegate & UINavigationControllerDelegate

public class RxImagePickerDelegateProxy:
	DelegateProxy<UIImagePickerController, UIImagePickerControllerProtocols>,
	DelegateProxyType, UIImagePickerControllerProtocols {
	
	public init(imagePicker: UIImagePickerController) {
		super.init(parentObject: imagePicker, delegateProxy: RxImagePickerDelegateProxy.self)
	}
	
	public static func registerKnownImplementations() {
		register { RxImagePickerDelegateProxy(imagePicker: $0) }
	}
	
	public static func currentDelegate(for object: UIImagePickerController) -> UIImagePickerControllerProtocols? {
		object.delegate
	}
	
	public static func setCurrentDelegate(_ delegate: UIImagePickerControllerProtocols?, to object: UIImagePickerController) {
		object.delegate = delegate
	}
}

extension Reactive where Base: UIImagePickerController {
	
	public var pickerDelegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerProtocols> {
		RxImagePickerDelegateProxy.proxy(for: base)
	}
	
	public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
		pickerDelegate
			.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
			.map { a in
				try castOrThrow([UIImagePickerController.InfoKey: AnyObject].self, a[1])
			}
	}
	
	public var didCancel: Observable<Void> {
		pickerDelegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
			.map { _ in () }
	}
	
	static func createdWithParent(
		_ parent: UIViewController?,
		animated: Bool = true,
		configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { _ in }
	) -> Observable<UIImagePickerController> {
		Observable.create { [weak parent] observer -> Disposable in
			let imagePicker = UIImagePickerController()
			let dismissDisposable = Observable.merge(
				imagePicker.rx.didFinishPickingMediaWithInfo.map { _ in },
				imagePicker.rx.didCancel
			)
			.subscribe(onNext: {
				observer.on(.completed)
			})
			
			do {
				try configureImagePicker(imagePicker)
			} catch let error {
				observer.onError(error)
			}
			
			guard let parent = parent else {
				observer.onCompleted()
				return Disposables.create()
			}
			parent.present(imagePicker, animated: animated, completion: nil)
			observer.onNext(imagePicker)
			return Disposables.create(dismissDisposable,
				Disposables.create {
					dismissViewController(imagePicker, animated: animated)
				}
			)
		}
	}
}

//转类型的函数（转换失败后，会发出Error）
fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
	guard let returnValue = object as? T else {
		throw RxCocoaError.castingError(object: object, targetType: resultType)
	}
	return returnValue
}

func dismissViewController(_ viewController: UIViewController, animated: Bool) {
	if viewController.isBeingDismissed || viewController.isBeingPresented {
		DispatchQueue.main.async {
			dismissViewController(viewController, animated: animated)
		}
		return
	}
	if viewController.presentingViewController != .none {
		viewController.dismiss(animated: animated, completion: .none)
	}
}
