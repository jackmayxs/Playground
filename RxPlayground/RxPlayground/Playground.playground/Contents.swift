import UIKit
import RxSwift
import RxCocoa

let bag = DisposeBag()

Infallible<Int>.empty()
    .asObservable()
    .debug()
    .observe(on: MainScheduler.instance)
    .subscribe()
    .disposed(by: bag)
