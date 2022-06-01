//
//  SwiftUIPlayground.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/7.
//  Copyright © 2022 Choi. All rights reserved.
//

import SwiftUI

@available(iOS 15, *)
struct SwiftUIPlayground: View {
	
	var thanks: AttributedString {
		var thanks = AttributedString("Thank you!")
		thanks.font = .body.bold()
		thanks.mergeAttributes(attributes)
		return thanks
	}
	
	var website: AttributedString {
		var website = AttributedString("Please visit our website.")
		website.font = .body.italic()
		website.link = URL(string: "https://www.baidu.com")
		website.mergeAttributes(attributes)
		
		let characterView = website.characters
		for i in characterView.indices where characterView[i].isPunctuation {
			website[i..<characterView.index(after: i)].foregroundColor = .orange
		}
		
		let firstRun = website.runs.first.unsafelyUnwrapped
		let slice = website.characters[firstRun.range]
		let firstString = String(slice)
		
		if let range = website.range(of: "visit") {
			website[range].font = .body.italic().bold()
			website.characters.replaceSubrange(range, with: "surf")
		}
		return website
	}
	
	var attributes: AttributeContainer {
		var container = AttributeContainer()
		container.foregroundColor = .black
		container.underlineColor = .blue
		return container
	}
	
    var body: some View {
        Text(website)
			.onAppear {
				print(website.runs.count)
			}
    }
}

@available(iOS 15, *)
struct PlayAround_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIPlayground()
    }
}
