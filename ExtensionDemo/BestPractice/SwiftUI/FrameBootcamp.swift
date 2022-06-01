//
//  FrameBootcamp.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/1/22.
//  Copyright © 2022 Choi. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
struct FrameBootcamp: View {
    var body: some View {
        Text("Hello, World!")
//			.background(.green)
//			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

			.background(.red)
			.frame(height: 100, alignment: .top)
			.background(.orange)
			.frame(width: 150)
			.background(.purple)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(.pink)
			.frame(height: 400)
			.background(.green)
			.frame(maxHeight: .infinity, alignment: .top)
			.background(.yellow)
    }
}

@available(iOS 15.0, *)
struct FrameBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        FrameBootcamp()
    }
}
