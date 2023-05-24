//
//  UIBaseTableViewHeaderFooterView.swift
//  zeniko
//
//  Created by Choi on 2022/8/23.
//

import UIKit

class UIBaseTableViewHeaderFooterView: UITableViewHeaderFooterView, StandardLayoutLifeCycle {
    
    /// 内容边距
    var contentInsets: UIEdgeInsets { .zero }
    
    /// 背景色
    var defaultBackgroundColor: UIColor { baseViewBackgroundColor }
    
    /// 高亮时的背景色
    var defaultHighlightBackgroundColor: UIColor? {
        defaultBackgroundColor
    }
    
    /// 选中时的背景色
    var defaultSelectedBackgroundColor: UIColor? {
        defaultBackgroundColor
    }
    
    // 圆角
    var preferredCornerRadius: CGFloat? { nil }
    
    /// 弱引用Cell本身的TableView | 用于分类中对TableView的缓存
    private weak var tableView_: UITableView?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    @available(iOS 14.0, *)
    override func updateConfiguration(using state: UIViewConfigurationState) {
        super.updateConfiguration(using: state)
        var background = UIBackgroundConfiguration.listPlainHeaderFooter()
        if state.isHighlighted {
            background.backgroundColor = defaultHighlightBackgroundColor ?? .clear
        } else if state.isSelected {
            background.backgroundColor = defaultSelectedBackgroundColor ?? .clear
        } else {
            background.backgroundColor = defaultBackgroundColor
        }
        /**
         一种新的设置颜色的方法
         */
//        background.backgroundColorTransformer = UIConfigurationColorTransformer { color in
//            color.withAlphaComponent(0.3)
//        }
        backgroundConfiguration = background
    }
    
    // 复写frame属性
    override var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue.inset(by: contentInsets)
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority) + contentInsets
    }
    
    func prepare() {
        if #unavailable(iOS 14.0) {
            contentView.backgroundColor = defaultBackgroundColor
        }
        prepareSubviews()
        prepareConstraints()
    }
    
    func prepareSubviews() {}
    
    func prepareConstraints() {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let preferredCornerRadius {
            roundCorners(cornerRadius: preferredCornerRadius)
        }
    }
}

extension UIBaseTableViewHeaderFooterView {
    
    var tableView: UITableView? {
        if let tableView_ {
            return tableView_
        } else {
            tableView_ = superview(UITableView.self)
            return tableView_
        }
    }
}
