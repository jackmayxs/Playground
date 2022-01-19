//
//  GeometryReaderPractice.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/1/19.
//  Copyright © 2022 Choi. All rights reserved.
//

import SwiftUI

struct InnerView: View {
	var body: some View {
		HStack {
			Text("Left")
			
			GeometryReader { proxy in
				Text("Center")
					.background(.blue)
					.onTapGesture {
						/// GeometryReader相对于整个屏幕的位置
						/// Global:  (37.66, 82.64, 289.33, 666.92)
						let globalFrame = proxy.frame(in: .global)
						
						/// GeometryReader自己的坐标
						/// Local:  (0.0, 0.0, 289.33, 666.92)
						let localFrame = proxy.frame(in: .local)
						
						/// GeometryReader相对于自定义坐标的位置(在此例子中为OuterView安全区域里的部分)
						/// Choi:  (37.66, 32.642, 289.33, 666.92)
						let customFrame = proxy.frame(in: .named("Choi"))
						
						print("Global: ", globalFrame)
						print("Local: ", localFrame)
						print("Choi: ", customFrame)
					}
			}
			.background(.orange)
			
			Text("Right")
		}
	}
}

struct OuterView: View {
	var body: some View {
		VStack {
			Text("Top")
			InnerView()
				.background(.green)
			Text("Bottom")
		}
	}
}

struct GeometryReaderPractice: View {
    var body: some View {
		OuterView()
			.background(.red)
			.coordinateSpace(name: "Choi")
    }
}

struct GeometryReaderPractice_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderPractice()
    }
}
