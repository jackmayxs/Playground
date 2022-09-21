//
//  UITableView+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/22.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    
    var numberOfRows: Observable<Int> {
        methodInvoked(#selector(UITableView.reloadData)).map { _ in
            guard let dataSource = base.dataSource else { return 0 }
            let sectionCount = dataSource.numberOfSections?(in: base) ?? 1
            return (0..<sectionCount).reduce(0) { partialResult, section in
                partialResult + dataSource.tableView(base, numberOfRowsInSection: section)
            }
        }
    }
    
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
