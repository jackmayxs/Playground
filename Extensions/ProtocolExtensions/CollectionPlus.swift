//
//  CollectionPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import Foundation

extension Collection {
    
    func filled(or defaultCollection: Self) -> Self {
        isNotEmpty ? self : defaultCollection
    }
    
    /// 如果为空则返回nil
    var filledOrNil: Self? {
        isNotEmpty ? self : nil
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
}
