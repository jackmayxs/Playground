//
//  UIBaseTableViewCell.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/7/19.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

class UIBaseTableViewCell: UITableViewCell, StandartLayoutLifeCycle {

	// 所在的indexPath
	var indexPath: IndexPath?
	// 内容边距
	var contentInsets: UIEdgeInsets { .zero }
    // 背景色
    var defaultBackgroundColor: UIColor { .white }
	// 分割线
	private lazy var separator = UIView(frame: .zero).configure {
		$0.isHidden = true
		$0.backgroundColor = customizedSeparatorColor
	}
	// 分割线高度
	var customizedSeparatorHeight: CGFloat { 1.0 }
	// 分割线颜色
	var customizedSeparatorColor: UIColor { #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1) }
    // 圆角
    var preferredCornerRadius: CGFloat { 10.0 }
    
    @available(iOS 14.0, *)
    var defaultBackgroundConfiguration: UIBackgroundConfiguration {
        .clear()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    func prepare() {
        if #available(iOS 14.0, *) {
            backgroundConfiguration = defaultBackgroundConfiguration
        }
        contentView.backgroundColor = defaultBackgroundColor
        prepareSubviews()
        prepareConstraints()
    }
    
    func prepareSubviews() {
        contentView.addSubview(separator)
    }
    
    func prepareConstraints() {}
    
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
    /// 实现Cell直接加分割线的效果
    /// 调用时机:tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    /// - Parameters:
    ///   - tableView: Cell容器TableView
    ///   - indexPath: 所在的indexPath
    /// - Returns: Cell本身
	func adjustSeparatorFor(_ tableView: UITableView, at indexPath: IndexPath) -> Self {
		tableView.separatorStyle = .none
		/// 第一次进入TableViewController时获取的sectionHeight不正常 所以这里做延迟1ms处理
		DispatchQueue.main.asyncAfter(deadline: indexPath.section + indexPath.row == 0 ? 0.001 : 0.0) {
            /// HeaderHeight + CellsHeight + FooterHeight
			let sectionHeight = tableView.rect(forSection: indexPath.section).height
            /// Section Header's frame
			let sectionHeaderRect = tableView.rectForHeader(inSection: indexPath.section)
            /// Section Footer's frame
			let sectionFooterRect = tableView.rectForFooter(inSection: indexPath.section)
            /// Cells Height
			let sectionCellsHeight = sectionHeight - sectionHeaderRect.height - sectionFooterRect.height
            if sectionCellsHeight > self.bounds.height {
                self.separator.isHidden = indexPath.row == 0
			} else {
                self.separator.isHidden = self.frame.maxY == sectionFooterRect.minY
			}
		}
		return self
	}
    
    @discardableResult
    /// 实现分组样式时,第一行和最后一行分别加圆角
    /// 调用时机:tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    /// - Parameters:
    ///   - tableView: Cell容器TableView
    ///   - indexPath: 所在的indexPath
    /// - Returns: Cell本身
    func adjustCornerRadiusFor(_ tableView: UITableView, at indexPath: IndexPath) -> Self {
        if indexPath.row == 0, tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1 {
            contentView.roundCorners(corners: .allCorners, cornerRadius: preferredCornerRadius)
        } else if indexPath.row == 0 {
            contentView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: preferredCornerRadius)
        } else if tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1 {
            contentView.roundCorners(corners: [.bottomLeft, .bottomRight], cornerRadius: preferredCornerRadius)
        } else {
            contentView.roundCorners(corners: .allCorners, cornerRadius: 0.0)
        }
        return self
    }
}
