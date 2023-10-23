//
//  NWPathMonitor+Rx.swift
//  KnowLED
//
//  Created by Choi on 2023/10/23.
//

import Foundation
import Network
import RxSwift
import RxCocoa

extension NWPathMonitor: ReactiveCompatible {}
extension Reactive where Base == NWPathMonitor {
    
    private func start() {
        let queue = DispatchQueue.global(qos: .background)
        base.start(queue: queue)
    }
    
    private func cancel() {
        base.cancel()
    }
    
    private func satisfiedPath(_ path: NWPath) -> NWPath? {
        path.status == .satisfied ? path : nil
    }
    
    var satisfiedPath: Observable<NWPath?> {
        Observable.create { observer in
            base.pathUpdateHandler = { path in
                observer.onNext(path)
            }
            return Disposables.create()
        }
        .startWith(base.currentPath)
        .map(satisfiedPath)
        .do(onSubscribed: start, onDispose: cancel)
    }
}
