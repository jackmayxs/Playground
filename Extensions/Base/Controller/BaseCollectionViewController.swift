//
//  BaseCollectionViewController.swift
//  GodoxCine
//
//  Created by Choi on 2023/2/16.
//

import UIKit

class BaseCollectionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    lazy var collectionView = makeCollectionView(layout: defaultLayout)
    
    lazy var emptyView = makeEmptyView()
    
    var defaultLayout: UICollectionViewLayout {
        UICollectionViewLayout()
    }
    
    /// 选中Cell之后是否立刻反选
    var deselectCellAfterCellSelection = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 配置Collection View
        configureCollectionView()
        /// 添加Collection View
        addCollectionView()
    }
    
    /// 添加Collection View
    /// 调用时机:viewDidLoad()
    func addCollectionView() {
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
    }
    
    /// 调用时机:viewDidLoad()
    func configureCollectionView() {
        collectionView.backgroundView = emptyView

        /// 占位图默认隐藏
        emptyView.isHidden = true

        UICollectionViewCell.registerFor(collectionView)
        UICollectionReusableView.registerFor(collectionView, kind: .header)
        UICollectionReusableView.registerFor(collectionView, kind: .footer)
    }
    
    /// 调用时机:懒加载
    func makeCollectionView(layout: UICollectionViewLayout) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delaysContentTouches = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = baseViewBackgroundColor
        return collectionView
    }
    
    /// 创建空视图
    func makeEmptyView() -> UIView {
        UIView()
    }
    // MARK: - CollectionView Delegates
    // 注意: 必须父类里有实现,代理方法才会调用
    /// 选中条目
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if deselectCellAfterCellSelection {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    // MARK: - CollectionView Datasource
    
    /// 每组条目数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 0 }
    
    /// 分组数
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    /// 生成Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell.dequeueReusableCell(from: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionReusableView.reuseId, for: indexPath)
    }
}
