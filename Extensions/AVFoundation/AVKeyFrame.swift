//
//  AVKeyFrame.swift
//  KnowLED
//
//  Created by Choi on 2024/4/1.
//

import UIKit
import CoreMedia

struct AVKeyFrame: CustomStringConvertible {
    let currentTime: CMTime
    let duration: CMTime
    let cgImage: CGImage
    
    var progress: Double {
        let tmpProgress = currentTime.seconds / duration.seconds
        return tmpProgress.isNormal ? tmpProgress : 0.0
    }
    
    var description: String {
        "\(currentTime.stringValue)/\(duration.stringValue)"
    }
}
