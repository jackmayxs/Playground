//
//  RxPlus.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/16.
//

import RxSwift
import RxCocoa

extension ObservableType {
    
    func `as`<T>(_ type: T.Type) -> Observable<T> {
        map { element in
            if let valid = element as? T {
                return valid
            }
            throw RxError.overflow
        }
    }
}

extension ObservableType where Element == Bool {
	
	var isFalse: Observable<Element> {
		filter { $0 == false }
	}
}

extension Observable where Element == Error {
    
    func tryAfter(_ timeInterval: RxTimeInterval, maxRetryCount: Int) -> Observable<Int> {
        enumerated().flatMap { index, error -> Observable<Int> in
            guard index < maxRetryCount else {
                return .error(error).observe(on: MainScheduler.asyncInstance)
            }
            return .just(0).delay(timeInterval, scheduler: MainScheduler.asyncInstance)
        }
    }
}

extension ObservableConvertibleType where Element: Equatable {
	
	func isEqualOriginValue() -> Observable<(value: Element, isEqualOriginValue: Bool)> {
		asObservable()
			.scan(nil) { acum, x -> (origin: Element, current: Element)? in
				if let acum = acum {
					return (origin: acum.origin, current: x)
				} else {
					return (origin: x, current: x)
				}
			}
			.map {
				($0!.current, isEqualOriginValue: $0!.origin == $0!.current)
			}
	}
}

extension ObservableConvertibleType {
	
	func repeatWhen<O: ObservableType>(_ notifier: O) -> Observable<Element> {
		notifier.map { _ in }
			.startWith(())
			.flatMap { _ -> Observable<Element> in
				self.asObservable()
			}
	}
}
