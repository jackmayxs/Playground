//
//  UICollectionReusableViewPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/6/9.
//

import UIKit

extension UICollectionReusableView {
    
    enum Associated {
        static var collectionView = UUID()
    }
    
    var collectionView: UICollectionView? {
        get {
            collectionView(UICollectionView.self)
        }
        set {
            objc_setAssociatedObject(self, &Associated.collectionView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func collectionView<T>(_ type: T.Type) -> T? where T: UICollectionView {
        if let existedCollectionView = objc_getAssociatedObject(self, &Associated.collectionView) as? T {
            return existedCollectionView
        }
        let fetchCollectionView = superview(type)
        objc_setAssociatedObject(self, &Associated.collectionView, fetchCollectionView, .OBJC_ASSOCIATION_ASSIGN)
        return fetchCollectionView
    }
}
