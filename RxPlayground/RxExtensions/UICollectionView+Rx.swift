//
//  UICollectionView+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/9/21.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    
    var numberOfItems: Observable<Int> {
        methodInvoked(#selector(UICollectionView.reloadData)).map { _ in
            guard let dataSource = base.dataSource else { return 0 }
            let sectionCount = dataSource.numberOfSections?(in: base) ?? 1
            return (0..<sectionCount).reduce(0) { partialResult, section in
                partialResult + dataSource.collectionView(base, numberOfItemsInSection: section)
            }
        }
    }
}
