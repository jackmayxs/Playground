//
//  BaseFlowLayoutCollectionViewController.swift
//  GodoxCine
//
//  Created by Choi on 2023/2/16.
//

import UIKit

class BaseFlowLayoutCollectionViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {

    lazy var flowLayout = makeFlowLayout()
    
    override var defaultLayout: UICollectionViewLayout {
        flowLayout
    }
    
    func makeFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        configureFlowLayout(layout)
        return layout
    }
    
    func configureFlowLayout(_ flowLayout: UICollectionViewFlowLayout) {
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 0, height: 0)
    }
}
