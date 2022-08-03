//
//  BaseTableViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/2.
//  Copyright © 2022 GODOX Photo Equipment Co.,Ltd. All rights reserved.
//

import UIKit

class BaseTableViewController<PrimaryCellType: UITableViewCell>: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
	lazy var tableView = newTableView()
    
    var tableViewStyle: UITableView.Style { .plain }
    
    override func loadView() {
        view = tableView
    }
    
    func configureTableView(_ tableView: UITableView) {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    func newTableView() -> UITableView {
        let table = UITableView(frame: .zero, style: tableViewStyle)
        table.delegate = self
        table.dataSource = self
        PrimaryCellType.registerFor(table)
        configureTableView(table)
        return table
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PrimaryCellType.dequeueReusableCell(from: tableView, indexPath: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func configureCell(_ cell: PrimaryCellType, at indexPath: IndexPath) {
        
    }
}
