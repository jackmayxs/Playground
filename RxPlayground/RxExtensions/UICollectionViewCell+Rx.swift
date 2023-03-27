//
//  UICollectionViewCell+Rx.swift
//  KnowLED
//
//  Created by Choi on 2023/3/27.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionViewCell {
    var prepareForReuse: Observable<[Any]> {
        methodInvoked(#selector(UICollectionViewCell.prepareForReuse))
    }
}
