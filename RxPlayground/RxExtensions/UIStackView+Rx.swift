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
        let add0 = addedArrangedSubview.withUnretained(base).map(\.0)
        let add1 = addedArrangedSubviewWithCustomSpacing.withUnretained(base).map(\.0)
        let remove = removedArrangedSubview.withUnretained(base).map(\.0)
        let insert0 = insertedArrangedSubview.withUnretained(base).map(\.0)
        let insert1 = insertedArrangedSubviewWithCustomSpacing.withUnretained(base).map(\.0)
        return Observable.merge(add0, add1, remove, insert0, insert1)
    }
    
    private var addedArrangedSubviewWithCustomSpacing: Observable<(UIView, CGFloat)> {
        methodInvoked(#selector(base.addArrangedSubview(_:afterSpacing:)))
            .compactMap { parameters in
                guard parameters.count == 2 else { return nil }
                guard let subview = parameters.first as? UIView else { return nil }
                guard let afterSpacing = parameters.last as? CGFloat else { return nil }
                return (subview, afterSpacing)
            }
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
    
    private var insertedArrangedSubviewWithCustomSpacing: Observable<(UIView, Int, CGFloat)> {
        methodInvoked(#selector(base.insertArrangedSubview(_:at:afterSpacing:)))
            .compactMap { parameters in
                guard parameters.count == 3 else { return nil }
                guard let subview = parameters[0] as? UIView else { return nil }
                guard let index = parameters[1] as? Int else { return nil }
                guard let afterSpacing = parameters[2] as? CGFloat else { return nil }
                return (subview, index, afterSpacing)
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
}
