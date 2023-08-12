//
//  StandardLayoutLifeCycle.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import UIKit

protocol StandardLayoutLifeCycle: UIView {
    
    func prepare()
    
    func prepareSubviews()
    
    func prepareConstraints()
}

extension StandardLayoutLifeCycle {
    
    func prepare() {
        prepareSubviews()
        prepareConstraints()
    }
}
