//
//  UIBaseCollectionViewCell.swift
//  zeniko
//
//  Created by Choi on 2022/9/19.
//

import UIKit

class UIBaseCollectionViewCell: UICollectionViewCell, StandardLayoutLifeCycle {
    
    var defaultBackgroundColor: UIColor { .white }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        contentView.backgroundColor = defaultBackgroundColor
        prepareSubviews()
        prepareConstraints()
    }
    
    func prepareSubviews() {}
    
    func prepareConstraints() {}
    
}
