//
//  BaseDynamicTableViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/18.
//

import UIKit
import Moya

class BaseDynamicTableViewController
<PrimaryCell: UITableViewCell, ViewModel: PagableViewModelType>: BaseTableViewController, PagableViewModelDelegate {
    
    lazy var viewModel = ViewModel()
    
    override func initialConfigure() {
        super.initialConfigure()
        
        configureViewModel()
    }
    
    func configureViewModel() {
        viewModel.delegate = self
    }
    
    override func prepareTargets() {
        super.prepareTargets()
        
        viewModel.fetchMoreData()
    }
    
    override func configureTableView() {
        super.configureTableView()
        PrimaryCell.registerFor(tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        PrimaryCell.dequeueReusableCell(from: tableView, indexPath: indexPath).configure { cell in
            configureCell(cell, at: indexPath)
        }
    }
    
    func configureCell(_ cell: PrimaryCell, at indexPath: IndexPath) {
        
    }
    
    // MARK: - PagableViewModelDelegate
    func itemsUpdated() {
        tableView.reloadData()
        emptyView.isHidden = viewModel.numberOfItems > 0
    }
}
