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
        dataReloaded.map { collectionView in
            guard let dataSource = collectionView.dataSource else { return 0 }
            let sectionCount = dataSource.numberOfSections?(in: base) ?? 1
            return (0..<sectionCount).reduce(0) { partialResult, section in
                partialResult + dataSource.collectionView(base, numberOfItemsInSection: section)
            }
        }
    }
    
    var dataReloaded: Observable<Base> {
        methodInvoked(#selector(base.reloadData))
            .withUnretained(base)
            .map(\.0)
    }
    
    var selectedIndexPaths: Observable<[IndexPath]> {
        Observable.combineLatest(itemSelectionChanged, dataReloaded)
            .withUnretained(base)
            .map(\.0.indexPathsForSelectedItems.orEmpty)
    }
    
    var itemSelectionChanged: Observable<IndexPath> {
        Observable.of(selectItemAt, itemSelected.observable, itemDeselected.observable).merge()
    }
    
    private var selectItemAt: Observable<IndexPath> {
        base.rx.methodInvoked(#selector(UICollectionView.selectItem(at:animated:scrollPosition:)))
            .map(\.first)
            .unwrapped
            .as(IndexPath.self)
    }
}
