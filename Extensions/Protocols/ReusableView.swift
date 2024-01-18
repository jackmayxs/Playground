//
//  ReusableView.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import UIKit

public protocol ReusableView: AnyObject {
    static var reuseId: String { get }
}

extension ReusableView {
    
    public static var reuseId: String {
        String(describing: self)
    }
    
    public static func registerTo(layout: UICollectionViewLayout) {
        layout.register(self, forDecorationViewOfKind: reuseId)
    }
}

extension UICollectionReusableView: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
extension UITableViewCell: ReusableView {}
