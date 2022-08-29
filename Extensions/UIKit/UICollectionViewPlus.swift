//
//  UICollectionViewPlus.swift
//  ExtensionDemo
//
//  Created by Major on 2021/3/15.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UICollectionReusableView: ReusableView {}
extension UICollectionReusableView {
	enum SupplementaryViewKind {
		case header
		case footer
		var raw: String {
			switch self {
				case .header: return UICollectionView.elementKindSectionHeader
				case .footer: return UICollectionView.elementKindSectionFooter
			}
		}
	}
	static func registerFor(_ collectionView: UICollectionView, kind: SupplementaryViewKind) {
		collectionView.register(self, forSupplementaryViewOfKind: kind.raw, withReuseIdentifier: Self.reuseId)
	}
	static func dequeReusableSupplementaryView(from collectionView: UICollectionView, kind: SupplementaryViewKind, indexPath: IndexPath) -> Self {
        collectionView.dequeueReusableSupplementaryView(ofKind: kind.raw, withReuseIdentifier: Self.reuseId, for: indexPath) as! Self
	}
}

extension UICollectionViewCell {
	static func registerFor(_ collectionView: UICollectionView) {
		collectionView.register(self, forCellWithReuseIdentifier: reuseId)
	}
	static func dequeueReusableCell(from collectionView: UICollectionView, indexPath: IndexPath) -> Self {
		collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseId, for: indexPath) as! Self
	}
}
