//
//  ContentView.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/6/27.
//  Copyright © 2022 Choi. All rights reserved.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
	private let motionManager = CMMotionManager()
	@Published var x = 0.0
	@Published var y = 0.0
	init() {
		motionManager.startDeviceMotionUpdates(to: .main) {
			[unowned self] motion, error in
			guard let attitude = motion?.attitude else { return }
			x = attitude.roll
			y = attitude.pitch
		}
	}
}

struct ContentView: View {
	@StateObject private var motion = MotionManager()
	
    var body: some View {
		Text("Hello World!")
    }
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
        ContentView()
    }
}
