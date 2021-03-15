//
//  UICollectionViewPlus.swift
//  ExtensionDemo
//
//  Created by Major on 2021/3/15.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UICollectionViewCell: ReusableView {}
extension UICollectionViewCell {
	static func registerFor(_ collectionView: UICollectionView) {
		collectionView.register(self, forCellWithReuseIdentifier: reuseIdentifier)
	}
	static func dequeueReusableCell(from collectionView: UICollectionView, indexPath: IndexPath) -> Self {
		collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseIdentifier, for: indexPath) as! Self
	}
}
