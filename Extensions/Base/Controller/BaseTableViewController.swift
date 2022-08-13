//
//  BaseTableViewController.swift
//  zeniko
//
//  Created by Choi on 2022/8/2.
//  Copyright © 2022 GODOX Photo Equipment Co.,Ltd. All rights reserved.
//

import UIKit

class BaseTableViewController<PrimaryCellType: UITableViewCell>: BaseViewController<RemoteView, BaseViewModel>, UITableViewDataSource, UITableViewDelegate {
    
	lazy var tableView = newTableView()
    
    var tableViewStyle: UITableView.Style { .plain }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView(tableView)
        addTableView()
    }
    
    /// 添加TableView
    /// 调用时机:viewDidLoad()
    func addTableView() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    /// 调用时机:viewDidLoad()
    func configureTableView(_ tableView: UITableView) {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        /// 注册Cell/HeaderFooter
        PrimaryCellType.registerFor(tableView)
        UITableViewHeaderFooterView.registerFor(tableView)
    }
    
    /// 调用时机:懒加载
    func newTableView() -> UITableView {
        let table = UITableView(frame: .zero, style: tableViewStyle)
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.delegate = self
        table.dataSource = self
        return table
    }
    // MARK: - Table View Delegate
    // 注意: 必须父类里有实现,代理方法才会调用
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UITableViewHeaderFooterView.dequeueReusableHeaderFooterView(from: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PrimaryCellType.dequeueReusableCell(from: tableView, indexPath: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UITableViewHeaderFooterView.dequeueReusableHeaderFooterView(from: tableView)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}
    
    func configureCell(_ cell: PrimaryCellType, at indexPath: IndexPath) {}
}