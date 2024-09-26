//
//  Int+RSSI.swift
//  KnowLED
//
//  Created by Choi on 2024/9/26.
//
//  RSSI(Received Signal Strength Indicator)

import Foundation

extension Int {
    
    /// 信号强度等级 | 0...4由弱到强
    var rssLevel: Int {
        switch self {
        case (-55)...0     : return 4
        case (-65)..<(-55) : return 3
        case (-75)..<(-65) : return 2
        case (-85)..<(-75) : return 1
        case      ..<(-85) : return 0
        default:
            assertionFailure("WRONG RSSI: (\(self)), CHECK YOUR SOURCE.")
            return 0
        }
    }
}
