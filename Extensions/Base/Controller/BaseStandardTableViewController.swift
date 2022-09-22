//
//  BaseStandardTableViewController.swift
//  zeniko
//
//  Created by Choi on 2022/9/22.
//
//  带一个默认Cell类型的表格视图

import UIKit

class BaseStandardTableViewController<Cell: UITableViewCell>: BaseTableViewController {

    override func configureTableView() {
        super.configureTableView()
        Cell.registerFor(tableView)
    }
    
    func configureCell(_ cell: Cell) {}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Cell.dequeueReusableCell(from: tableView, indexPath: indexPath)
        configureCell(cell)
        return cell
    }
}
