//
//  UITableViewPlus.swift
//  ExtensionDemo
//
//  Created by Major on 2021/3/15.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UITableView {
	
	/// 在视图控制器的viewDidLayoutSubviews()方法里调用此方法以自动布局HeaderFooterView
	func layoutHeaderFooterViewIfNeeded() {
		if let headerView = tableHeaderView {
			let fitSize = CGSize(width: bounds.size.width, height: UIView.layoutFittingCompressedSize.height)
			let layoutSize = headerView.systemLayoutSizeFitting(fitSize)
			guard headerView.frame.size != layoutSize else { return }
			headerView.frame.size = layoutSize
			tableHeaderView = headerView
		}
		if let footerView = tableFooterView {
			let fitSize = CGSize(width: bounds.size.width, height: UIView.layoutFittingCompressedSize.height)
			let layoutSize = footerView.systemLayoutSizeFitting(fitSize)
			guard footerView.frame.size != layoutSize else { return }
			footerView.frame.size = layoutSize
			tableFooterView = footerView
		}
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

extension UITableViewHeaderFooterView: ReusableView {}
extension UITableViewHeaderFooterView {
	static func registerFor(_ tableView: UITableView) {
		tableView.register(self, forHeaderFooterViewReuseIdentifier: reuseId)
	}
	static func dequeueReusableHeaderFooterView(from tableView: UITableView) -> Self? {
		tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId) as? Self
	}
}
