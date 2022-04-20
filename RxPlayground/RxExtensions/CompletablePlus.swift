//
//  CompletablePlus.swift
//  RxPlayground
//
//  Created by Major on 2022/4/20.
//

import RxSwift

extension Array where Element == Completable {
    var chained: Completable {
        reduce(Completable.empty()) { chainedCompletable, element in
            chainedCompletable.andThen(element)
        }
    }
}

extension Completable {
    
    func andThen(_ completableBuilder: () -> Completable) -> Completable {
        andThen(completableBuilder())
    }
    
    func concatMap<Source: ObservableConvertibleType>(_ selector: () throws -> Source)
    -> Observable<Source.Element> {
        do {
            let next = try selector().asObservable()
            return andThen(next)
        } catch {
            return .error(error)
        }
    }
}
