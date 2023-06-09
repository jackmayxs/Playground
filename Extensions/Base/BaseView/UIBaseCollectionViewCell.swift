//
//  UIBaseCollectionViewCell.swift
//
//  Created by Choi on 2022/9/19.
//

import UIKit

class UIBaseCollectionViewCell: UICollectionViewCell, StandardLayoutLifeCycle {
    
    /// 直接复写Cell的backgroundColor属性会有循环调用问题
    /// 所以重新定义一个背景色属性
    var defaultBackgroundColor: UIColor? {
        willSet {
            if #unavailable(iOS 14.0) {
                contentView.backgroundColor = newValue
            }
        }
        didSet {
            if #available(iOS 14.0, *) {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    private var indexPath_: IndexPath?
    
    var indexPath: IndexPath? {
        get {
            let maybeIndexPath = collectionView?.indexPathForItem(at: center)
            defer {
                if let maybeIndexPath {
                    indexPath_ = maybeIndexPath
                }
            }
            return indexPath_ ?? maybeIndexPath
        }
        set {
            indexPath_ = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(iOS 14.0, *)
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        var background: UIBackgroundConfiguration
        if let defaultBackgroundColor {
            background = .listPlainCell()
            background.backgroundColor = defaultBackgroundColor
        } else {
            background = .clear()
        }
        
        backgroundConfiguration = background
    }
    
    func prepare() {
        defaultBackgroundColor = .clear
        prepareSubviews()
        prepareConstraints()
    }
    
    func prepareSubviews() {}
    
    func prepareConstraints() {}
    
}
