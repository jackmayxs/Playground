//
//  BaseDynamicFlowLayoutCollectionViewController.swift
//  GodoxCine
//
//  Created by Choi on 2023/2/17.
//

import UIKit

class BaseDynamicFlowLayoutCollectionViewController<FlowLayout: UICollectionViewFlowLayout, Cell: UICollectionViewCell, ViewModel: PagableViewModelType>: BaseFlowLayoutCollectionViewController<FlowLayout>, PagableViewModelDelegate {
    
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
    
    override func configureCollectionView() {
        super.configureCollectionView()
        Cell.registerFor(collectionView)
    }
    
    func configureCell(_ cell: Cell, at indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = Cell.dequeueReusableCell(from: collectionView, indexPath: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    // MARK: - PagableViewModelDelegate
    func itemsUpdated() {
        collectionView.reloadData()
        emptyView.isHidden = viewModel.numberOfItems > 0
    }
}
