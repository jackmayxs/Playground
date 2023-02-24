//
//  UICollectionViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/3/15.
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
        init?(rawValue: String) {
            if rawValue == UICollectionView.elementKindSectionHeader {
                self = .header
            } else if rawValue == UICollectionView.elementKindSectionFooter {
                self = .footer
            } else {
                return nil
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


extension UICollectionViewFlowLayout {
    
    // MARK: - 先从代理方法里获取各项参数 | 再使用默认属性
    func sectionInsetsAt(_ indexPath: IndexPath) -> UIEdgeInsets {
        guard let collectionView else { return sectionInset }
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return sectionInset }
        return delegate.collectionView?(collectionView, layout: self, insetForSectionAt: indexPath.section) ?? sectionInset
    }
    
    func minimumInteritemSpacingForSectionAt(_ indexPath: IndexPath) -> CGFloat {
        guard let collectionView else { return minimumInteritemSpacing }
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return minimumInteritemSpacing }
        return delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section) ?? minimumInteritemSpacing
    }
    
    func minimumLineSpacingForSectionAt(_ indexPath: IndexPath) -> CGFloat {
        guard let collectionView else { return minimumLineSpacing }
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return minimumLineSpacing }
        return delegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: indexPath.section) ?? minimumLineSpacing
    }
}
