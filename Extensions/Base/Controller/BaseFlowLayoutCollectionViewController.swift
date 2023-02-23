//
//  BaseFlowLayoutCollectionViewController.swift
//  GodoxCine
//
//  Created by Choi on 2023/2/16.
//

import UIKit

class BaseFlowLayoutCollectionViewController<FlowLayout: UICollectionViewFlowLayout>: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {

    lazy var flowLayout = makeFlowLayout()
    
    override var defaultLayout: UICollectionViewLayout {
        flowLayout
    }
    
    var numberOfColumns: CGFloat {
        2.0
    }
    
    var cellHeight: CGFloat {
        50.0
    }
    
    func makeFlowLayout() -> FlowLayout {
        let layout = FlowLayout()
        configureFlowLayout(layout)
        return layout
    }
    
    override func makeEmptyView() -> UIView {
        ZKTableViewEmptyView()
    }
    
    func configureFlowLayout(_ flowLayout: FlowLayout) {
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.sectionInset = 8
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = flowLayout.sectionInsetsAt(indexPath).horizontal
        let columnSpaces = (numberOfColumns - 1.0) * flowLayout.minimumInteritemSpacingForSectionAt(indexPath)
        let itemsWidth = collectionView.bounds.width - sectionInset - columnSpaces
        let itemWidth = (itemsWidth / numberOfColumns) - 1.0
        return CGSize(width: itemWidth, height: cellHeight)
    }
}
