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
    
    /// 只包括一个元素或无元素
    var containsSingleElementOrEmpty: Bool {
        count <= 1
    }
    
    /// 只包含一个元素
    var containsSingleElement: Bool {
        count == 1
    }
    
    /// 如果为空则返回nil
    var filledOrNil: Self? {
        isNotEmpty ? self : nil
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
}
