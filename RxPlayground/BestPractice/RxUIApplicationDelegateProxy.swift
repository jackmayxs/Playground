//
//  RxUIApplicationDelegateProxy.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/29.
//	⚠️注意: 这个类在基于SceneDelegate的项目中不适用! 需要另外编写基于SceneDelegate的类
//	或者使用NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)监听

import UIKit
import RxSwift
import RxCocoa

public enum AppState {
	case active
	case inactive
	case background
	case terminated
}

public class RxUIApplicationDelegateProxy:
	DelegateProxy<UIApplication, UIApplicationDelegate>,
	DelegateProxyType, UIApplicationDelegate {

	public weak private(set) var application: UIApplication?

	init(application: ParentObject) {
		self.application = application
		super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
	}

	public static func registerKnownImplementations() {
		self.register {
			RxUIApplicationDelegateProxy(application: $0)
		}
	}

	public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
		object.delegate
	}

	public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?, to object: UIApplication) {
		object.delegate = delegate
	}

	public override func setForwardToDelegate(_ delegate: DelegateProxy<UIApplication, UIApplicationDelegate>.Delegate?, retainDelegate: Bool) {
		super.setForwardToDelegate(delegate, retainDelegate: true)
	}
}

// MARK: - __________ Extensions __________
extension AppState: CustomStringConvertible {
	public var description: String {
		switch self {
			case .active: return "活跃"
			case .inactive: return "不活跃"
			case .background: return "进入后台"
			case .terminated: return "终止"
		}
	}
}
extension UIApplication.State {
	var appState: AppState {
		switch self {
			case .active: return .active
			case .inactive: return .inactive
			case .background: return .background
			@unknown default: fatalError()
		}
	}
}

extension Reactive where Base: UIApplication {

	var delegate: DelegateProxy<UIApplication, UIApplicationDelegate> {
		RxUIApplicationDelegateProxy.proxy(for: base)
	}

	var didBecomeActive: Observable<AppState> {
		delegate
			.methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
			.map { _ in .active }
	}

	var willResignActive: Observable<AppState> {
		delegate
			.methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:)))
			.map { _ in .inactive }
	}

	var willEnterForeground: Observable<AppState> {
		delegate
			.methodInvoked(#selector(UIApplicationDelegate.applicationWillEnterForeground(_:)))
			.map { _ in .inactive }
	}

	var didEnterBackground: Observable<AppState> {
		delegate
			.methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
			.map { _ in .background }
	}

	var willTerminate: Observable<AppState> {
		delegate
			.methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:)))
			.map { _ in .terminated }
	}

	var state: Observable<AppState> {
		Observable.merge(
			didBecomeActive,
			willResignActive,
			willEnterForeground,
			didEnterBackground,
			didEnterBackground,
			willTerminate
		)
		.startWith(base.applicationState.appState)
	}
}
