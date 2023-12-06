//
//  UIStackView+Rx.swift
//  KnowLED
//
//  Created by Choi on 2023/12/6.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIStackView {
    
//    var intrinsicContentSize: Observable<CGSize> {
//        arrangedSubviewsChanged.withUnretained(base).map(\.0.intrinsicContentSize)
//    }
//    
//    private var arrangedSubviewsChanged: Observable<Any> {
//        Observable.merge(addArrangedSubview.anyElement, removeArrangedSubview.anyElement, insertArrangedSubview.anyElement)
//    }
//    
//    private var addArrangedSubview: Observable<UIView> {
//        methodInvoked(#selector(base.addArrangedSubview))
//            .compactMap { parameters in
//                parameters.first as? UIView
//            }
//    }
//    
//    private var removeArrangedSubview: Observable<UIView> {
//        methodInvoked(#selector(base.removeArrangedSubview))
//            .compactMap { parameters in
//                parameters.first as? UIView
//            }
//    }
//    
//    private var insertArrangedSubview: Observable<(UIView, Int)> {
//        methodInvoked(#selector(base.addArrangedSubview))
//            .compactMap { parameters in
//                guard parameters.count == 2 else { return nil }
//                guard let subview = parameters.first as? UIView,let index = parameters.last as? Int else { return nil }
//                return (subview, index)
//            }
//    }
}
