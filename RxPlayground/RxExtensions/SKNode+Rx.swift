//
//  SKNode+Rx.swift
//  KnowLED
//
//  Created by Choi on 2023/9/15.
//

import UIKit
import SpriteKit
import RxSwift
import RxCocoa

extension Reactive where Base: SKNode {
    
    var position: Observable<CGPoint> {
        observe(\.position, options: .live)
    }
}
