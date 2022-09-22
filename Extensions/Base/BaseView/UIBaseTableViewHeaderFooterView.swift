//
//  UIBaseTableViewHeaderFooterView.swift
//  zeniko
//
//  Created by Choi on 2022/8/23.
//

import UIKit

class UIBaseTableViewHeaderFooterView: UITableViewHeaderFooterView, StandardLayoutLifeCycle {
    
    // 内容边距
    var contentInsets: UIEdgeInsets { .zero }
    // 背景色
    var defaultBackgroundColor: UIColor { .white }
    // 圆角
    var preferredCornerRadius: CGFloat? { nil }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
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
        contentView.backgroundColor = defaultBackgroundColor
        prepareSubviews()
        prepareConstraints()
    }
    func prepareSubviews() {}
    func prepareConstraints() {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let preferredCornerRadius {
            contentView.roundCorners(cornerRadius: preferredCornerRadius)
        }
    }
}
