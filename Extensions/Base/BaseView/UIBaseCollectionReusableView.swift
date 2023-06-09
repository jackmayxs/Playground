//
//  UIBaseCollectionReusableView.swift
//
//  Created by Choi on 2023/5/22.
//

import UIKit

class UIBaseCollectionReusableView: UICollectionReusableView, StandardLayoutLifeCycle {

    private var indexPath_: IndexPath?
    
    var indexPath: IndexPath? {
        get {
            let maybeIndexPath = collectionView?.indexPathForItem(at: center)
            defer {
                if let maybeIndexPath {
                    indexPath_ = maybeIndexPath
                }
            }
            return indexPath_ ?? maybeIndexPath
        }
        set {
            indexPath_ = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    func prepare() {
        prepareSubviews()
        prepareConstraints()
    }
    
    func prepareSubviews() {}
    
    func prepareConstraints() {}
}
