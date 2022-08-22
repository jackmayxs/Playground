//
//  UITableView+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/22.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    
    var isAllRowsSelected: Observable<Bool> {
        selectedIndexPaths.map { selectedPaths in
            let sectionCount = base.numberOfSections
            var rowsCount = 0
            for section in 0..<sectionCount {
                rowsCount += base.numberOfRows(inSection: section)
            }
            return selectedPaths.count == rowsCount
        }
    }
    
    var selectedIndexPaths: Observable<[IndexPath]> {
        itemTapped.map { _ in
            base.indexPathsForSelectedRows ?? []
        }
    }
    
    var itemTapped: Observable<IndexPath> {
        Observable.of(itemSelected, itemDeselected).merge()
    }
}
