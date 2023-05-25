//
//  UIScrollView+Rx.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/30.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    
    /// 合并事件
    /// 用于更新自定义滚动条
    var contentSizeAndVisibleContentBounds: Observable<(CGSize, CGRect)> {
        Observable.combineLatest(contentSize, visibleContentBounds)
    }
    
    var contentSize: ControlProperty<CGSize> {
        let binder = Binder(base, scheduler: MainScheduler.instance) { scroll, newContentSize in
            guard newContentSize != scroll.contentSize else { return }
            scroll.contentSize = newContentSize
        }
        return ControlProperty(values: observedContentSize, valueSink: binder)
    }
    
    /// KVO contentSize
    var observedContentSize: Observable<CGSize> {
        observe(\.contentSize, options: [.initial, .new]).distinctUntilChanged()
    }
    
    /// base.contentOffset +
    /// base.bounds.size
    var visibleContentBounds: Observable<CGRect> {
        didLayoutSubviews.map(\.bounds)
    }
    
	var reachedBottom: Signal<()> {
		contentOffset.asDriver()
			.flatMap { [weak base] contentOffset -> Signal<()> in
				guard let scrollView = base else { return .empty() }
				// 可视区域高度
				let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
				// 滚动条最大位置
				let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
				// 如果当前位置超出最大位置则发出一个事件
				let y = contentOffset.y + scrollView.contentInset.top
				return y > threshold ? Signal.just(()) : Signal.empty()
			}
	}
}
