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
        dataReloaded.map { tableView in
            guard let dataSource = tableView.dataSource else { return 0 }
            let sectionCount = dataSource.numberOfSections?(in: base) ?? 1
            return (0..<sectionCount).reduce(0) { partialResult, section in
                partialResult + dataSource.tableView(base, numberOfRowsInSection: section)
            }
        }
    }
    
    var dataReloaded: Observable<Base> {
        methodInvoked(#selector(base.reloadData))
            .withUnretained(base)
            .map(\.0)
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
        rowSelectionChanged
            .withUnretained(base)
            .compactMap(\.0.indexPathsForSelectedRows)
    }
    
    var rowSelectionChanged: Observable<IndexPath> {
        Observable.of(selectRowAt, itemSelected.observable, itemDeselected.observable).merge()
    }
    
    private var selectRowAt: Observable<IndexPath> {
        base.rx.methodInvoked(#selector(base.selectRow(at:animated:scrollPosition:)))
            .map(\.first)
            .unwrapped
            .as(IndexPath.self)
    }
}
