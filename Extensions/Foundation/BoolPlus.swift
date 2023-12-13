//
//  BoolPlus.swift
//
//  Created by Choi on 2022/8/18.
//

import Foundation

extension Bool {
    
    var toggled: Bool {
        !self
    }
    
    var isTrue: Bool {
        self == true
    }
    
    var isFalse: Bool {
        self == false
    }
}
