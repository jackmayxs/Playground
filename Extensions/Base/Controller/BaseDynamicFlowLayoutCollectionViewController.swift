//
//  BaseDynamicFlowLayoutCollectionViewController.swift
//
//  Created by Choi on 2023/2/17.
//

import UIKit

class BaseDynamicFlowLayoutCollectionViewController<FlowLayout: UICollectionViewFlowLayout, Cell: UICollectionViewCell, Header: UICollectionReusableView, Footer: UICollectionReusableView, ViewModel: PagableViewModelType>: BaseFlowLayoutCollectionViewController<FlowLayout, Cell, Header, Footer>, PagableViewModelDelegate {
    
    lazy var viewModel = ViewModel(delegate: self)
    
    override func initialConfigure() {
        super.initialConfigure()
        
        configureViewModel()
    }
    
    func configureViewModel() {
        viewModel.delegate = self
    }
    
    override func prepareTargets() {
        super.prepareTargets()
        
        viewModel.fetchMoreData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    // MARK: - PagableViewModelDelegate
    func itemsUpdated() {
        collectionView.reloadData()
        emptyView.isHidden = viewModel.numberOfItems > 0
    }
}
