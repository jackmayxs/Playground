//
//  UIApplication+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/9/29.
//

import RxSwift
import RxCocoa

extension UIApplication {
    
    static var needsUpdate: Driver<Bool> {
        latestRelease.map { release in
            release?.needsUpdate ?? false
        }
    }
    
    static var latestRelease: Driver<Release?> {
        Single.create { observer in
            self.getLatestRelease { release in
                observer(.success(release))
            }
            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: nil)
    }
}
