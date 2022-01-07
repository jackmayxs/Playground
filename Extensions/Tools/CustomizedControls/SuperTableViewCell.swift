//
//  SuperTableViewCell.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/7/19.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

class SuperTableViewCell: UITableViewCell {

	// 所在的indexPath
	var indexPath: IndexPath?
	// 内容边距
	var contentInsets: UIEdgeInsets { .zero }
	// 分割线
	private lazy var separator = UIView(frame: .zero).configure {
		$0.isHidden = true
		$0.backgroundColor = customizedSeparatorColor
	}
	// 分割线高度
	var customizedSeparatorHeight: CGFloat { 1.0 }
	// 分割线颜色
	var customizedSeparatorColor: UIColor { #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1) }
	// 复写frame属性
	override var frame: CGRect {
		get { super.frame }
		set {
			super.frame = newValue.inset(by: contentInsets)
			var insets: UIEdgeInsets {
				UIEdgeInsets(
					top: 0,
					left: separatorInset.left,
					bottom: bounds.height - customizedSeparatorHeight,
					right: separatorInset.right
				)
			}
			separator.frame = bounds.inset(by: insets)
		}
	}
	override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
		super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority) + contentInsets
	}
	@discardableResult
	func adjustSeparatorFor(_ tableView: UITableView, at indexPath: IndexPath) -> Self {
		tableView.separatorStyle = .none
		/// 第一次进入TableViewController时获取的sectionHeight不正常 所以这里做延迟1ms处理
		DispatchQueue.main.asyncAfter(deadline: indexPath.section + indexPath.row == 0 ? 0.001 : 0.0) {
			let sectionHeight = tableView.rect(forSection: indexPath.section).height
			let sectionHeaderRect = tableView.rectForHeader(inSection: indexPath.section)
			let sectionFooterRect = tableView.rectForFooter(inSection: indexPath.section)
			let sectionCellsHeight = sectionHeight - sectionHeaderRect.height - sectionFooterRect.height
			if sectionCellsHeight > self.bounds.height {
				self.separator.isHidden = indexPath.row == 0
			} else {
				self.separator.isHidden = self.frame.maxY == sectionFooterRect.minY
			}
		}
		return self
	}
}
