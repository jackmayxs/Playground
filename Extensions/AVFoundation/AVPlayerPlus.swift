//
//  AVPlayerPlus.swift
//  KnowLED
//
//  Created by Choi on 2024/4/1.
//

import AVFoundation

extension AVPlayer {
    
    /// 播放器更新进度
    static func *(lhs: AVPlayer, rhs: Double) {
        guard let playerItem = lhs.currentItem else { return }
        let targetPosition = playerItem.duration.seconds * rhs
        let time = CMTime(seconds: targetPosition, preferredTimescale: playerItem.duration.timescale)
        guard time.isValid else { return }
        lhs.seek(to: time)
    }
    
    /// 如果之前为暂停则开始播放
    func resumeIfNeeded() {
        if rate.isZero {
            play()
        }
    }
    
    func replay() {
        seek(to: .zero)
        play()
    }
}
