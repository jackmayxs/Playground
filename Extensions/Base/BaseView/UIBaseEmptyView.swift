//
//  UIBaseEmptyView.swift
//  GodoxCine
//
//  Created by Choi on 2023/3/2.
//

import UIKit

class UIBaseEmptyView: UIBaseView {

    /// 设置为UITableView的emptyView属性似乎不受safeArea的管理
    /// 所以子视图在布局的时候要将约束直接设置到父视图上,而不是safeareaLayoutGuide
    override func layoutSubviews() {
        super.layoutSubviews()
        if let superview {
            bounds = superview.bounds
        }
    }

}
