//
//  KeyPathPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/4/7.
//

import Foundation

extension KeyPath {
    var pureKeyPath: String? {
        let rawKeyPath = "\(self)"
        if let dotIndex = rawKeyPath.firstIndex(of: ".") {
            let questionMark = CharacterSet(charactersIn: "?")
            var result = rawKeyPath[rawKeyPath.index(dotIndex, offsetBy: 1)..<rawKeyPath.endIndex]
            result.removeCharacters(in: questionMark)
            return result.string
        }
        return nil
    }
}
