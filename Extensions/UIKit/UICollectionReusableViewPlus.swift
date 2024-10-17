//
//  UICollectionReusableViewPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/6/9.
//

import UIKit

extension UICollectionReusableView {
    
    enum Associated {
        @UniqueAddress static var collectionView
    }
    
    var inferredIndexPath: IndexPath? {
        collectionView?.indexPathForItem(at: center)
    }
    
    var collectionView: UICollectionView? {
        get {
            collectionView(UICollectionView.self)
        }
        set {
            setAssociatedObject(self, Associated.collectionView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func collectionView<T>(_ type: T.Type) -> T? where T: UICollectionView {
        if let existedCollectionView = associated(T.self, self, Associated.collectionView) {
            return existedCollectionView
        }
        let fetchCollectionView = superview(type)
        setAssociatedObject(self, Associated.collectionView, fetchCollectionView, .OBJC_ASSOCIATION_ASSIGN)
        return fetchCollectionView
    }
}
