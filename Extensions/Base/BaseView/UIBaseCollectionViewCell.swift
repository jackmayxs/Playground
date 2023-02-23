//
//  UIBaseCollectionViewCell.swift
//  zeniko
//
//  Created by Choi on 2022/9/19.
//

import UIKit

class UIBaseCollectionViewCell: UICollectionViewCell, StandardLayoutLifeCycle {
    
    var defaultBackgroundColor: UIColor { .white }
    
    private weak var collectionView_: UICollectionView?
    
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

extension UIBaseCollectionViewCell {
    
    var collectionView: UICollectionView? {
        if let collectionView_ {
            return collectionView_
        } else {
            collectionView_ = superview(UICollectionView.self)
            return collectionView_
        }
    }
    
    // 所在的indexPath
    var indexPath: IndexPath? {
        collectionView?.indexPath(for: self)
    }
}
