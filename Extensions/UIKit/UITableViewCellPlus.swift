//
//  UITableViewCellPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/6/9.
//

import UIKit

extension UITableViewCell {
    
    enum Associated {
        static var tableView = UUID()
    }
    
    var inferredIndexPath: IndexPath? {
        tableView?.indexPath(for: self)
    }
    
    var tableView: UITableView? {
        get {
            tableView(UITableView.self)
        }
        set {
            objc_setAssociatedObject(self, &Associated.tableView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func tableView<T>(_ type: T.Type) -> T? where T: UITableView {
        if let existedTableView = objc_getAssociatedObject(self, &Associated.tableView) as? T {
            return existedTableView
        }
        let fetchTableView = superview(type)
        objc_setAssociatedObject(self, &Associated.tableView, fetchTableView, .OBJC_ASSOCIATION_ASSIGN)
        return fetchTableView
    }
}

extension UITableViewCell: ReusableView {}
extension UITableViewCell {
    static func registerFor(_ tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: reuseId)
    }
    static func dequeueReusableCell(from tableView: UITableView, indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: Self.reuseId, for: indexPath) as! Self
    }
}
