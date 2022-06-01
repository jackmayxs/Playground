//
//  BuyViewController.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/30.
//  Copyright © 2022 Choi. All rights reserved.
//

import UIKit

final class BuyView: UIView {
	
	fileprivate let rootFlexContainer = UIView()
	fileprivate let icon = UIImageView(image: #imageLiteral(resourceName: "hei"))
	fileprivate let title = UILabel(text: "Title")
	fileprivate let subTitle = UILabel(text: "Subtitle")
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

final class BuyViewController: BaseViewController<BuyCoordinator> {
	var selectedProduct = 0
	
	override var preferLargeTitles: Bool { false }
	
	override func loadView() {
		view = BuyView()
	}
}

extension BuyViewController: Storyboarded {}
