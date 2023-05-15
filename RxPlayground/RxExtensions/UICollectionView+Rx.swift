//
//  UICollectionView+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/9/21.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    
    var page: ControlProperty<Int> {
        let finalOffset = didEndDecelerating.withUnretained(base).map(\.0.contentOffset)
        let targetOffset = willEndDragging.map(\.targetContentOffset.pointee)
        let mergedOffset = Observable.merge(finalOffset, targetOffset)
        
        let observedPage = mergedOffset.withUnretained(base).map { collectionView, offset in
            let contentSize = collectionView.contentSize
            var axis = NSLayoutConstraint.Axis.horizontal
            if contentSize.height > collectionView.bounds.height {
                axis = .vertical
            }
            switch axis {
            case .horizontal:
                guard collectionView.bounds.width > 0 else { return 0 }
                return Int(offset.x / collectionView.bounds.width)
            case .vertical:
                guard collectionView.bounds.height > 0 else { return 0 }
                return Int(offset.y / collectionView.bounds.height)
            @unknown default:
                return 0
            }
        }
            .distinctUntilChanged()
        
        let binder = Binder(base, scheduler: MainScheduler.instance) { collectionView, page in
            guard 0... ~= page else { return }
            let contentSize = collectionView.contentSize
            var axis = NSLayoutConstraint.Axis.horizontal
            if contentSize.height > collectionView.bounds.height {
                axis = .vertical
            }
            switch axis {
            case .horizontal:
                collectionView.contentOffset = CGPoint(x: page.double * collectionView.bounds.width, y: 0)
            case .vertical:
                collectionView.contentOffset = CGPoint(x: 0, y: page.double * collectionView.bounds.height)
            @unknown default:
                break
            }
        }
        return ControlProperty(values: observedPage, valueSink: binder)
    }
    
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
