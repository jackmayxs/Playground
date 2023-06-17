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
            guard let indexPath_ else {
                guard let fetchIndexPath = collectionView?.indexPathForItem(at: center) else { return nil }
                indexPath_ = fetchIndexPath
                return fetchIndexPath
            }
            return indexPath_
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
