//
//  UITableViewCell+Rx.swift
//  RxPlayground
//
//  Created by Choi on 2022/4/20.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITableViewCell {
    var prepareForReuse: Observable<[Any]> {
        methodInvoked(#selector(UITableViewCell.prepareForReuse))
    }
}
