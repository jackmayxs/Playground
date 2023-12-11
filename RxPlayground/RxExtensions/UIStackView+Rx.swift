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
    
    var naturalSize: Observable<CGSize> {
        arrangedSubviewsChanged
            .startWith(base)
            .map(\.naturalSize)
            .removeDuplicates
    }
    
    private var arrangedSubviewsChanged: Observable<Base> {
        let add = addArrangedSubview.withUnretained(base).map(\.0)
        let remove = removeArrangedSubview.withUnretained(base).map(\.0)
        let insert = insertArrangedSubview.withUnretained(base).map(\.0)
        return Observable.merge(add, remove, insert)
    }
    
    private var addArrangedSubview: Observable<UIView> {
        methodInvoked(#selector(base.addArrangedSubview))
            .compactMap { parameters in
                parameters.first as? UIView
            }
    }
    
    private var removeArrangedSubview: Observable<UIView> {
        methodInvoked(#selector(base.removeArrangedSubview))
            .compactMap { parameters in
                parameters.first as? UIView
            }
    }
    
    private var insertArrangedSubview: Observable<(UIView, Int)> {
        methodInvoked(#selector(base.addArrangedSubview))
            .compactMap { parameters in
                guard parameters.count == 2 else { return nil }
                guard let subview = parameters.first as? UIView,let index = parameters.last as? Int else { return nil }
                return (subview, index)
            }
    }
}
