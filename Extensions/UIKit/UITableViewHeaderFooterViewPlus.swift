//
//  UITableViewHeaderFooterViewPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/6/9.
//

import UIKit

extension UITableViewHeaderFooterView {
    
    enum Associated {
        static var tableView = UUID()
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

extension UITableViewHeaderFooterView: ReusableView {}
extension UITableViewHeaderFooterView {
    static func registerFor(_ tableView: UITableView) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: reuseId)
    }
    static func dequeueReusableHeaderFooterView(from tableView: UITableView) -> Self? {
        tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId) as? Self
    }
}
