//
//  AVPlayerPlus.swift
//  KnowLED
//
//  Created by Choi on 2024/4/1.
//

import AVFoundation

extension AVPlayer {
    
    /// 播放器更新进度
    static func *(player: AVPlayer, progress: Double) {
        guard let playerItem = player.currentItem else { return }
        let targetPosition = playerItem.duration.seconds * progress
        let time = CMTime(seconds: targetPosition, preferredTimescale: playerItem.duration.timescale)
        guard time.isValid else { return }
        player.seek(to: time)
    }
    
    /// 如果正在播放则先暂停
    func pauseIfNeeded() {
        if !rate.isZero {
            pause()
        }
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
