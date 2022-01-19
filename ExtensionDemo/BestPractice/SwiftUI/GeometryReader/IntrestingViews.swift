//
//  IntrestingViews.swift
//  SwiftUIDemo
//
//  Created by Choi on 2021/1/20.
//  Copyright © 2021 Choi. All rights reserved.
//

import SwiftUI

struct AlbumView: View {
	
	let colors: [Color] = [
		.red, .green, .blue, .yellow, .pink, .gray, .orange
	]
	
	var body: some View {
		GeometryReader { fullView in
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					ForEach(0..<50) { index in
						GeometryReader { geo in
							Rectangle()
								.fill(colors[index % 7])
								.frame(height: 150)
								.rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 10), axis: (0, 1, 0))
						}
						.frame(width: 150)
					}
				}
				.padding(.horizontal, (fullView.size.width - 150) / 2)
			}
		}
		.edgesIgnoringSafeArea(.all)
	}
}

struct DNAView: View {
	
	let colors: [Color] = [
		.red, .green, .blue, .yellow, .pink, .gray, .orange
	]
	
	var body: some View {
		GeometryReader { fullView in
			ScrollView(.vertical) {
				ForEach(0..<50) { index in
					GeometryReader { geo in
						Text("Row #\(index)")
							.font(.title)
							.frame(width: fullView.size.width)
							.background(colors[index % 7])
							.rotation3DEffect(.degrees(Double(geo.frame(in: .global).minY - fullView.size.height / 2) / 5),
											  axis: (x: 0, y: 1, z: 0)
							)
					}
					.frame(height: 40)
				}
			}
		}
	}
}

struct InterstingViewPreview: PreviewProvider {
	static var previews: some View {
		DNAView()
	}
}
