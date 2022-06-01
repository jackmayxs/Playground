//
//  CustomLayoutGuilde.swift
//  SwiftUIDemo
//
//  Created by Choi on 2022/1/17.
//  Copyright © 2022 Choi. All rights reserved.
//

import SwiftUI

extension VerticalAlignment {
    
    /// 糖葫芦布局
    enum StringTogether: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }
    
    static let stringTogether = VerticalAlignment(StringTogether.self)
}

extension ViewDimensions {
    var vCenter: CGFloat {
        self[VerticalAlignment.center]
    }
    var hCenter: CGFloat {
        self[HorizontalAlignment.center]
    }
}

@available(iOS 15.0, *)
struct CustomLayoutGuilde: View {
    var body: some View {
        HStack(alignment: .stringTogether) {
            VStack {
                Text("Hello Left VStack")
                    .alignmentGuide(.stringTogether, computeValue: \.vCenter)
                Image(systemName: "paperplane.circle.fill")
                    .frame(width: 64, height: 64)
                    .background(.red)
                Text("World!")
                Text("World!")
                Text("World!")
                Text("World!")
            }
            VStack {
                Text("Hello")
                Text("Hello")
                Text("Hello")
                Text("Hello")
                Text("Hello")
                Text("World!")
                    .alignmentGuide(.stringTogether, computeValue: \.vCenter)
                    .font(.largeTitle)
            }
        }
        .background(.blue)
    }
}

@available(iOS 15.0, *)
struct CustomLayoutGuilde_Previews: PreviewProvider {
    static var previews: some View {
        CustomLayoutGuilde()
    }
}
