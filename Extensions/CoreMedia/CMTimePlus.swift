//
//  CMTimePlus.swift
//  KnowLED
//
//  Created by Choi on 2024/4/1.
//

import CoreMedia

extension CMTime {
    var stringValue: String {
        guard seconds.isNormal else { return "00:00" }
        return seconds.durationDescription
    }
}
