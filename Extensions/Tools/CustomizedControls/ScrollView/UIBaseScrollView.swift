//
//  UIBaseScrollView.swift
//  zeniko
//
//  Created by Choi on 2022/8/15.
//

import UIKit

class UIBaseScrollView: UIBaseView {
    
    let scrollView = TouchesDelayedScrollView()
    let contentView = UIView()
    
    override func prepare() {
        super.prepare()
        contentView.backgroundColor = defaultBackgroundColor
        configScrollView(scrollView)
    }
    
    func configScrollView(_ scrollView:UIScrollView) {
        scrollView.contentInsetAdjustmentBehavior = .automatic
        scrollView.keyboardDismissMode = .interactive
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    override func prepareSubviews() {
        super.prepareSubviews()
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    override func prepareConstraints() {
        super.prepareConstraints()
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
