//
//  Rx+UIViewController.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/15.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
	
	var viewDidLoad: ControlEvent<Void> {
		let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
		return ControlEvent(events: source)
	}
	
	var viewWillAppear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewWillAppear))
			.map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
	var viewDidAppear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewDidAppear))
			.map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
	
	var viewWillDisappear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewWillDisappear))
			.map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
	var viewDidDisappear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewDidDisappear))
			.map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
	
	var viewWillLayoutSubviews: ControlEvent<Void> {
		let source = methodInvoked(#selector(Base.viewWillLayoutSubviews))
			.map { _ in }
		return ControlEvent(events: source)
	}
	var viewDidLayoutSubviews: ControlEvent<Void> {
		let source = methodInvoked(#selector(Base.viewDidLayoutSubviews))
			.map { _ in }
		return ControlEvent(events: source)
	}
	
	var willMoveToParentViewController: ControlEvent<UIViewController?> {
		let source = methodInvoked(#selector(Base.willMove))
			.map { $0.first as? UIViewController }
		return ControlEvent(events: source)
	}
	var didMoveToParentViewController: ControlEvent<UIViewController?> {
		let source = methodInvoked(#selector(Base.didMove))
			.map { $0.first as? UIViewController }
		return ControlEvent(events: source)
	}
	
	var didReceiveMemoryWarning: ControlEvent<Void> {
		let source = methodInvoked(#selector(Base.didReceiveMemoryWarning))
			.map { _ in }
		return ControlEvent(events: source)
	}
	
	//表示视图是否显示的可观察序列，当VC显示状态改变时会触发
	var isVisible: Observable<Bool> {
		let viewDidAppearObservable = base.rx.viewDidAppear.map { _ in true }
		let viewWillDisappearObservable = base.rx.viewWillDisappear.map { _ in false }
		return Observable<Bool>
            .merge(viewDidAppearObservable, viewWillDisappearObservable)
            .startWith(false)
	}
	
	//表示页面被释放的可观察序列，当VC被dismiss时会触发
	var isDismissing: ControlEvent<Bool> {
		let source = sentMessage(#selector(Base.dismiss))
			.map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
}
