//
//  UIBaseVerticalScrollView.swift
//
//  Created by Choi on 2022/8/15.
//

import UIKit

class UIBaseVerticalScrollView: UIBaseScrollView {
    override func prepareConstraints() {
        super.prepareConstraints()
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
