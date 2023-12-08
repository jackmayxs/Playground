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
    
    /// 观察固有尺寸
    /// - Parameter stretchAxis: 拉伸的轴向
    /// - Returns: UIStackView固有尺寸
    func intrinsicContentSize(stretchAxis: NSLayoutConstraint.Axis) -> Observable<CGSize> {
        let liveStackView = arrangedSubviewsChanged
        let superviewDidLayoutSubviews = superView.compactMap(\.itself).flatMapLatest(\.rx.didLayoutSubviews)
        return Observable.combineLatest(liveStackView, superviewDidLayoutSubviews).map { stackView, superview in
            var superSize = superview.bounds.size
            switch stretchAxis {
            case .horizontal:
                superSize.width = .greatestFiniteMagnitude
            case .vertical:
                superSize.height = .greatestFiniteMagnitude
            @unknown default:
                fatalError("Unhandled condition")
            }
            return stackView.preferredSize(maxSize: superSize, stretchAxis: stretchAxis)
        }
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
