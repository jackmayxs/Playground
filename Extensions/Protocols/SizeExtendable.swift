//
//  SizeExtendable.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import UIKit

protocol SizeExtendable {
    
    /// 垂直方向扩展
    var vertical: CGFloat { get }
    
    /// 水平方向扩展
    var horizontal: CGFloat { get }
}
