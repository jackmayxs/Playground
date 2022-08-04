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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView()
    }
    
    /// 添加TableView
    /// 调用时机:viewDidLoad()
    func addTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 调用时机:newTableView()
    func configureTableView(_ tableView: UITableView) {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    /// 调用时机:懒加载
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
