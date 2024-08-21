//
//  CMTimePlus.swift
//  KnowLED
//
//  Created by Choi on 2024/4/1.
//

import CoreMedia

extension CMTime {
    
    var durationDescription: String {
        guard seconds.isNormal else { return "00:00" }
        return seconds.durationDescription
    }
    
    /// (测试用)打印详情
    func show() {
        CMTimeShow(self)
    }
}
