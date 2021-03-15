//
//  UITableViewPlus.swift
//  ExtensionDemo
//
//  Created by Major on 2021/3/15.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UITableViewCell: ReusableView {}
extension UITableViewCell {
	static func registerFor(_ tableView: UITableView) {
		tableView.register(self, forCellReuseIdentifier: reuseIdentifier)
	}
	static func dequeueReusableCell(from tableView: UITableView, indexPath: IndexPath) -> Self {
		tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as! Self
	}
}
