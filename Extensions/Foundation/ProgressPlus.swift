//
//  ProgressPlus.swift
//
//  Created by Choi on 2022/10/12.
//

import Foundation

extension Progress {
    
    static let started: Progress = {
        let progress = Progress(totalUnitCount: 100)
        progress.completedUnitCount = 0
        return progress
    }()
    
    static let finished: Progress = {
        let progress = Progress(totalUnitCount: 100)
        progress.completedUnitCount = 100
        return progress
    }()
}
