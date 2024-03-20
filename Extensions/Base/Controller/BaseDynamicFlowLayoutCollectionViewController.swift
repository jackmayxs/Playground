//
//  BaseDynamicFlowLayoutCollectionViewController.swift
//
//  Created by Choi on 2023/2/17.
//

import UIKit

class BaseDynamicFlowLayoutCollectionViewController<
FlowLayout: UICollectionViewFlowLayout,
Cell: UICollectionViewCell,
Header: UICollectionReusableView,
Footer: UICollectionReusableView,
ViewModel: PagableViewModelType>: BaseFlowLayoutCollectionViewController<
FlowLayout,
Cell,
Header,
Footer>, PagableViewModelDelegate {
    
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    // MARK: - PagableViewModelDelegate
    /// 注: PagableViewModelType需要继续优化,加入分组数量适配,item考虑使用[[Model]]形式
    func sectionsUpdated(_ indexSet: IndexSet?) {
        collectionView.reloadData()
        emptyView.isHidden = viewModel.numberOfItems > 0
    }
    func itemsUpdated(_ indexPaths: [IndexPath]?) {
        collectionView.reloadData()
        emptyView.isHidden = viewModel.numberOfItems > 0
    }
}
