//
//  UIViewControllerPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/3/3.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
	
	private struct Preview: UIViewControllerRepresentable {
		
		let viewController: UIViewController

		func makeUIViewController(context: Context) -> UIViewController { viewController }

		func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
	}

	var preview: some View {
		Preview(viewController: self)
	}
}
#endif
