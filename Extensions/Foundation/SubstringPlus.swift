//
//  SubstringPlus.swift
//
//  Created by Choi on 2023/4/7.
//

import Foundation

extension Substring {
    
    mutating func removeCharacters(in notAllowed: CharacterSet) {
        unicodeScalars.removeAll { scalar in
            notAllowed.contains(scalar)
        }
    }
}
