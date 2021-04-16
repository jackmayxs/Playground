//
//  RxPlus.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/16.
//

import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
	
	var isTrue: Observable<Element> {
		filter { $0 }
	}
	var isFalse: Observable<Element> {
		filter { !$0 }
	}
}
