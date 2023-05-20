//
//  UICollectionReusableView+Rx.swift
//  KnowLED
//
//  Created by Choi on 2023/5/20.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionReusableView {
    var prepareForReuse: Observable<[Any]> {
        methodInvoked(#selector(UICollectionReusableView.prepareForReuse))
    }
}
