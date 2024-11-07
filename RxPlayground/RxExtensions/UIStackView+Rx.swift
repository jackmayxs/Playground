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
        let add = addedArrangedSubview.withUnretained(base).map(\.0)
        let remove = removedArrangedSubview.withUnretained(base).map(\.0)
        let insert = insertedArrangedSubview.withUnretained(base).map(\.0)
        let setAfterSpacing = setCustomSpacingAfterArrangedSubview.withUnretained(base).map(\.0)
        return Observable.merge(add, remove, insert, setAfterSpacing)
    }
    
    private var addedArrangedSubview: Observable<UIView> {
        methodInvoked(#selector(base.addArrangedSubview(_:)))
            .compactMap { parameters in
                parameters.first as? UIView
            }
    }
    
    private var removedArrangedSubview: Observable<UIView> {
        methodInvoked(#selector(base.removeArrangedSubview))
            .compactMap { parameters in
                parameters.first as? UIView
            }
    }
    
    private var insertedArrangedSubview: Observable<(UIView, Int)> {
        methodInvoked(#selector(base.insertArrangedSubview(_:at:)))
            .compactMap { parameters in
                guard parameters.count == 2 else { return nil }
                guard let subview = parameters.first as? UIView else { return nil }
                guard let index = parameters.last as? Int else { return nil }
                return (subview, index)
            }
    }
    
    private var setCustomSpacingAfterArrangedSubview: Observable<(CGFloat, UIView)> {
        methodInvoked(#selector(base.setCustomSpacing(_:after:)))
            .compactMap { parameters in
                guard parameters.count == 2 else { return nil }
                guard let afterSpacing = parameters.first as? CGFloat else { return nil }
                guard let subview = parameters.last as? UIView else { return nil }
                return (afterSpacing, subview)
            }
    }
}
