//
//  AVPlayer+Rx.swift
//  KnowLED
//
//  Created by Choi on 2024/4/1.
//

import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base == AVPlayer {
    
    /// 计算当前进度及当前视频帧数据
    /// - Parameter itemVideoOutput: 视频采集Output
    func keyFrame(_ itemVideoOutput: AVPlayerItemVideoOutput) -> Observable<AVKeyFrame> {
        Observable.create { observer in
            let queue = DispatchQueue(label: "com.observing.playback", qos: .userInitiated)
            /// 采样间隔(16ms采样一次,按60fps计算)
            let interval = CMTime(value: 16, timescale: 1000)
            /// 观察者
            let timeObserver = base.addPeriodicTimeObserver(forInterval: interval, queue: queue) {
                [unowned base] cmTime in
                guard let playerItem = base.currentItem else { return }
                let currentTime = cmTime
                let duration = playerItem.duration
                guard let cgImage = cgImage(itemVideoOutput, at: cmTime) else { return }
                let keyFrame = AVKeyFrame(currentTime: currentTime, duration: duration, cgImage: cgImage)
                observer.onNext(keyFrame)
            }
            return Disposables.create {
                base.removeTimeObserver(timeObserver)
            }
        }
    }
    
    /// 当前时间的CGImage对象 | 宽高尺寸为视频源数据帧的宽高
    private func cgImage(_ itemVideoOutput: AVPlayerItemVideoOutput, at time: CMTime) -> CGImage? {
        guard let cvImageBuffer = itemVideoOutput.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) else { return nil }
        let ciContextOptions: [CIContextOption: Any] = [:]
        let ciContext = CIContext(options: ciContextOptions)
        let ciImage = CIImage(cvImageBuffer: cvImageBuffer)
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)
        return cgImage
    }
}
