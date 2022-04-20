//
//  UIScrollView+Rx.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/30.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
	
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
