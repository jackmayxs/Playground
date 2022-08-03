//
//  UIBaseView.swift
//  zeniko
//
//  Created by Choi on 2022/8/3.
//

import UIKit

class UIBaseView: UIView, StandartLayoutLifeCycle {

    var defaultBackgroundColor: UIColor { .white }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    func prepare() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = defaultBackgroundColor
        prepareSubviews()
        prepareConstraints()
    }
    
    func prepareSubviews() {}
    
    func prepareConstraints() {}
    
}
