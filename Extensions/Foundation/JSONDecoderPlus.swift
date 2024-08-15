//
//  JSONDecoderPlus.swift
//  KnowLED
//
//  Created by Choi on 2024/8/7.
//

import Foundation

extension JSONDecoder {
    
    /// 通用JSONDecoder
    static let common = JSONDecoder()
    
    /// 时间以毫秒解析的Decoder
    static let millisecondsDateDecodingDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
}
