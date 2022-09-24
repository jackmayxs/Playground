//
//  UIBaseTableViewCell.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/7/19.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

class UIBaseTableViewCell: UITableViewCell, StandardLayoutLifeCycle {
    /// 分割线类
    final class _UIBaseTableViewCellSeparatorView: UIView {}
    
    /// 弱引用Cell本身的TableView | 用于分类中对TableView的缓存
    private weak var tableView_: UITableView?
    
    /// 缩进之后的边距
    private var indentedContentInsets: UIEdgeInsets {
        contentInsets.left(contentInsets.left + indentationOffset)
    }
    
    /// 内容边距
    var contentInsets: UIEdgeInsets { .zero }
    
    /// 背景色
    var defaultBackgroundColor: UIColor { .white }
    
    /// 分割线
    private lazy var separator = _UIBaseTableViewCellSeparatorView(frame: .zero).configure {
        $0.isHidden = true
        $0.backgroundColor = customizedSeparatorColor
    }
    /// 分割线像素高度 | 子类重写此属性并返回nil则不显示自定义的分割线
    var separatorPixelHeight: Int? { 1 }
    
    /// 分割线颜色
    var customizedSeparatorColor: UIColor { #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1) }
    
    /// 圆角
    var preferredCornerRadius: CGFloat? { nil }
    
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
        if separatorPixelHeight.isValid {
            contentView.addSubview(separator)
        }
    }
    
    func prepareConstraints() {}
    
    private var indentationOffset: CGFloat {
        CGFloat(indentationLevel) * indentationWidth
    }
    
    /// 复写frame属性
    override var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue.inset(by: indentedContentInsets)
            
            /// 这里正是处于 UITableViewDataSource 的 tableView(_:cellForRowAt:)的生命周期中
            if let tableView, let indexPath = tableView.indexPath(for: self) {
                
                /// 设置分割线
                if let separatorPixelHeight {
                    /// 根据缩进布局分割线
                    var separatorIndets: UIEdgeInsets {
                        UIEdgeInsets(
                            top: 0,
                            left: separatorInset.left + indentationOffset,
                            bottom: bounds.height - separatorPixelHeight.cgFloat / UIScreen.main.scale,
                            right: separatorInset.right
                        )
                    }
                    separator.frame = bounds.inset(by: separatorIndets)
                    
                    /// 如果发现系统的分割线则隐藏它
                    /// 注: 第一次进入Table的时候,有的Cell会出现系统分割线
                    /// (lldb) po subviews
                    /// ▿ 3 elements
                    ///   - 0 : <_UISystemBackgroundView>
                    ///   - 1 : <UITableViewCellContentView>
                    ///   - 2 : <_UITableViewCellSeparatorView>
                    ///   系统分隔线常出现子视图数组的最后一个元素 | 这里做反转处理: Complexity: O(1)
                    let maybeSystemSeparator = subviews.reversed()
                        .first { subview in
                            subview.className == "_UITableViewCellSeparatorView"
                        }
                    if let maybeSystemSeparator {
                        maybeSystemSeparator.isHidden = true
                    }
                    
                    /// 调整分割线显示/隐藏
                    adjustSeparatorFor(tableView, at: indexPath)
                }
                
                /// 设置圆角
                if let preferredCornerRadius {
                    setCornerRadius(preferredCornerRadius, for: tableView, at: indexPath)
                }
            }
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority) + indentedContentInsets
    }
}

extension UIBaseTableViewCell {
    
    var tableView: UITableView? {
        if let tableView_ {
            return tableView_
        } else {
            tableView_ = parentSuperView(UITableView.self)
            return tableView_
        }
    }
    
    // 所在的indexPath
    var indexPath: IndexPath? {
        tableView?.indexPath(for: self)
    }
    
    /// 实现Cell直接加分割线的效果
    /// - Parameters:
    ///   - tableView: Cell容器TableView
    ///   - indexPath: 所在的indexPath
    private func adjustSeparatorFor(_ tableView: UITableView, at indexPath: IndexPath) {
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
            if sectionCellsHeight > self.frame.height {
                self.separator.isHidden = indexPath.row == 0
            } else {
                self.separator.isHidden = self.frame.maxY == sectionFooterRect.minY
            }
        }
    }
    
    /// 实现分组样式时,第一行和最后一行分别加圆角
    /// 调用时机:tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    /// - Parameters:
    ///   - tableView: Cell容器TableView
    ///   - indexPath: 所在的indexPath
    /// - Returns: Cell本身
    private func setCornerRadius(_ cornerRadius: CGFloat, for tableView: UITableView, at indexPath: IndexPath) {
        if indexPath.row == 0, tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1 {
            contentView.roundCorners(corners: .allCorners, cornerRadius: cornerRadius)
        } else if indexPath.row == 0 {
            contentView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: cornerRadius)
        } else if tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1 {
            contentView.roundCorners(corners: [.bottomLeft, .bottomRight], cornerRadius: cornerRadius)
        } else {
            contentView.roundCorners(corners: .allCorners, cornerRadius: 0.0)
        }
    }
}
