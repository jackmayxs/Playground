//
//  NewUIButtonSystem.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/12/10.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
class NewUIButtonSystem: UIButton {

	override func updateConfiguration() {
		guard var updatedConfig = configuration else { return }
		var background = UIButton.Configuration.plain().background
		background.cornerRadius = 20
		background.strokeWidth = 1
		
		let strokeColor: UIColor
		let foregroundColor: UIColor
		let backgroundColor: UIColor
		let baseColor = updatedConfig.baseForegroundColor ?? UIColor.tintColor
		
		switch state {
		case .normal:
			strokeColor = .systemGray5
			foregroundColor = baseColor
			backgroundColor = .clear
		case [.highlighted]:
			strokeColor = .systemGray5
			foregroundColor = baseColor
			backgroundColor = baseColor.withAlphaComponent(0.3)
		case .selected:
			strokeColor = .clear
			foregroundColor = .white
			backgroundColor = baseColor
		case [.selected, .highlighted]:
			strokeColor = .clear
			foregroundColor = .white
			backgroundColor = baseColor.darker()
		case .disabled:
			strokeColor = .systemGray6
			foregroundColor = baseColor.withAlphaComponent(0.3)
			backgroundColor = .clear
		default:
			strokeColor = .systemGray5
			foregroundColor = baseColor
			backgroundColor = .clear
		}
		background.strokeColor = strokeColor
		/// You can think of transformer as a map function
		/// that takes in input and produce a new output without changing the input.
		///
		/// Instead of set .backgroundColor which affect the state of the next update,
		/// we set .backgroundColorTransformer which return a background color we want instead.
		background.backgroundColorTransformer = UIConfigurationColorTransformer { _ in
			return backgroundColor
		}
		
		/// The same rule apply to .baseForegroundColor.
		/// We don't want to change this and mess up the next update.
		/// We apply a new foregroundColor to an AttributeContainer and return it from the transformer.
		/// This change also solves our disabled text color problem
		updatedConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { input in
			var container = input
			container.foregroundColor = foregroundColor
			return container
		}
		updatedConfig.background = background
		configuration = updatedConfig
	}

}

extension UIColor {
	func darker() -> UIColor {
		var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
		
		if self.getRed(&r, green: &g, blue: &b, alpha: &a){
			return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
		}
		
		return UIColor()
	}
}
