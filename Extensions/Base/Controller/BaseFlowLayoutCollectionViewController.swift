//
//  BaseFlowLayoutCollectionViewController.swift
//
//  Created by Choi on 2023/2/16.
//

import UIKit

class BaseFlowLayoutCollectionViewController<FlowLayout: UICollectionViewFlowLayout, Cell: UICollectionViewCell, Header: UICollectionReusableView, Footer: UICollectionReusableView>: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {

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
    
    override func makeEmptyView() -> UIView {
        ZKTableViewEmptyView()
    }
    
    override func configureCollectionView(_ collectionView: UICollectionView) {
        super.configureCollectionView(collectionView)
        Cell.registerFor(collectionView)
        Header.registerFor(collectionView, kind: .header)
        Footer.registerFor(collectionView, kind: .footer)
    }
    
    func configureFlowLayout(_ flowLayout: FlowLayout) {}
    
    func makeFlowLayout() -> FlowLayout {
        let layout = FlowLayout()
        configureFlowLayout(layout)
        return layout
    }
    
    func configureCell(_ cell: Cell, at indexPath: IndexPath) { }
    
    func configureHeader(_ header: Header, at section: Int) { }
    
    func configureFooter(_ footer: Footer, at section: Int) { }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = flowLayout.sectionInsetsAt(indexPath).horizontal
        let columnSpaces = (numberOfColumns - 1.0) * flowLayout.minimumInteritemSpacingForSectionAt(indexPath)
        let itemsWidth = collectionView.bounds.width - sectionInset - columnSpaces
        let itemWidth = (itemsWidth / numberOfColumns) - 1.0
        return CGSize(width: itemWidth, height: cellHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = Cell.dequeueReusableCell(from: collectionView, indexPath: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryViewKind = UICollectionReusableView.SupplementaryViewKind(rawValue: kind) else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
        switch supplementaryViewKind {
        case .header:
            let header = Header.dequeReusableSupplementaryView(from: collectionView, kind: supplementaryViewKind, indexPath: indexPath)
            configureHeader(header, at: indexPath.section)
            return header
        case .footer:
            let footer = Footer.dequeReusableSupplementaryView(from: collectionView, kind: supplementaryViewKind, indexPath: indexPath)
            configureFooter(footer, at: indexPath.section)
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height)
        return headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath)
        let targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height)
        return headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}
