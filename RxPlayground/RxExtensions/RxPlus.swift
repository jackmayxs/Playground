//
//  RxPlus.swift
//  RxPlayground
//
//  Created by Choi on 2021/4/16.
//

import RxSwift
import RxCocoa

extension DisposeBag {
    func insert(@ArrayBuilder<Disposable> builder: () -> [Disposable]) {
        let disposables = builder()
        insert(disposables)
    }
}

@propertyWrapper
class Variable<Wrapped> {
    
    private let projectedValue_: BehaviorRelay<Wrapped>
    var projectedValue: BehaviorRelay<Wrapped> {
        projectedValue_
    }
    init(wrappedValue: Wrapped) {
        projectedValue_ = BehaviorRelay(value: wrappedValue)
    }
    
    var wrappedValue: Wrapped {
        get { projectedValue_.value }
        set { projectedValue_.accept(newValue) }
    }
}

@propertyWrapper
final class ClamppedVariable<T>: Variable<T> where T: Comparable {
    
    private let range: ClosedRange<T>
    
    init(wrappedValue: T, range: ClosedRange<T>) {
        self.range = range
        super.init(wrappedValue: wrappedValue)
    }
    
    override var projectedValue: BehaviorRelay<T> {
        super.projectedValue
    }
    
    override var wrappedValue: T {
        get { super.wrappedValue }
        set {
            guard range ~= newValue else {
                if newValue > range.upperBound {
                    super.wrappedValue = range.upperBound
                } else if newValue < range.lowerBound {
                    super.wrappedValue = range.lowerBound
                }
                return
            }
            super.wrappedValue = newValue
        }
    }
}

extension ObservableType {
    
    
    /// 获取非空的上一个元素 和 当前元素
    var validPreviousAndCurrentElement: Observable<(previous: Element, current: Element)> {
        previousAndCurrentElement.compactMap { previous, current in
            guard let previous else { return nil }
            return (previous, current)
        }
    }
    
    /// 获取上一个元素 和 当前元素
    var previousAndCurrentElement: Observable<(previous: Element?, current: Element)> {
        scan(Array<Element>.empty) { array, next in
            var tempArray = array
            tempArray.append(next)
            return tempArray.suffix(2)
        }
        .map { array in
            (array.count > 1 ? array.first : nil, array.last.unsafelyUnwrapped)
        }
        
//        /// 参考的网络上的实现
//        multicast(PublishSubject.init) { subjectValues -> Observable<(current: Element, previous: Element)> in
//            /// 合并时间线: 第一个元素 + 当前元素
//            let previousValues = Observable.merge(subjectValues.take(1), subjectValues)
//            /// 合并数据: 当前元素 + 上一个元素
//            return Observable.combineLatest(subjectValues, previousValues) {
//                ($0, $1)
//            }
//        }
    }
    
    /// 订阅完成事件
    ///   - object: 弱引用对象
    /// - Parameter completed: 完成回调
    /// - Returns: Disposable
    public func subscribeCompletedEvent<Object: AnyObject>(
        with object: Object,
        _ completed: @escaping (Object) -> Void)
    -> Disposable {
        subscribe(with: object, onCompleted: completed)
    }
    
    /// 订阅完成事件
    /// - Parameter completed: 完成回调
    /// - Returns: Disposable
    public func subscribeCompletedEvent(_ completed: @escaping SimpleCallback) -> Disposable {
        subscribe(onCompleted: completed)
    }
    
    
    /// onNext事件触发执行一个简单回调
    /// - Parameter execute: 回调方法
    /// - Returns: Disposable
    public func trigger(_ execute: @escaping SimpleCallback) -> Disposable {
        subscribe { _ in
            execute()
        } onError: { error in
            dprint(error)
        }
    }
    
    /// 绑定忽略Error事件的序列
    /// 错误事件由上层调用.trackError(ErrorTracker)处理错误
    /// - Parameter observers: 观察者们
    /// - Returns: Disposable
    public func bindErrorIgnored<Observer: ObserverType>(to observers: Observer...) -> Disposable where Observer.Element == Element {
        subscribe { nextElement in
            observers.forEach { observer in
                observer.onNext(nextElement)
            }
        } onError: { error in
            dprint(error)
        }
    }

    /// 绑定忽略Error事件的序列
    /// 错误事件由上层调用.trackError(ErrorTracker)处理错误
    /// - Parameter observers: 观察者们
    /// - Returns: Disposable
    public func bindErrorIgnored<Observer: ObserverType>(to observers: Observer...) -> Disposable where Observer.Element == Element? {
        asOptional(Element.self).subscribe { nextElement in
            observers.forEach { observer in
                observer.onNext(nextElement)
            }
        } onError: { error in
            dprint(error)
        }
    }
    
    /// 绑定忽略Error事件的序列
    /// - Parameters:
    ///   - object: 弱引用的对象
    ///   - onNext: Next事件
    /// - Returns: Disposable
    public func bindErrorIgnored<Object: AnyObject>(with object: Object, onNext: @escaping (Object, Element) -> Void) -> Disposable {
        subscribe {
            [weak object] nextElement in
            guard let object else { return }
            onNext(object, nextElement)
        } onError: { error in
            dprint(error)
        }
    }
    
    /// 绑定忽略Error事件的序列
    /// - Parameter onNext: Next事件
    /// - Returns: Disposable
    public func bindErrorIgnored(onNext: @escaping (Element) -> Void) -> Disposable {
        subscribe(onNext: onNext) { error in
            dprint(error)
        }
    }
}

extension ObservableConvertibleType {
    
    
    static var empty: Observable<Element> {
        .empty()
    }
    
    /// Observable 稳定性测试 | 指定时间内是否发出指定个数的事件
    /// - Parameters:
    ///   - timeSpan: 经过的时间 | 默认不检查时间 0 纳秒
    ///   - unStableCount: 最多发出的事件数量 | 默认 1 个
    ///   - scheduler: 运行的Scheduler | 默认留空, 默认创建一个串行队列
    /// - Returns: Observable是否输出稳定的事件序列
    func stabilityCheck(timeSpan: RxTimeInterval = .nanoseconds(0), unStableCount: Int = 1, scheduler: SchedulerType? = nil) -> Observable<Bool> {
        let queueName = "com.chek.observable.stable.or.not"
        lazy var defaultScheduler = SerialDispatchQueueScheduler(qos: .default, internalSerialQueueName: queueName)
        return asObservable()
            .window(timeSpan: timeSpan, count: .max, scheduler: scheduler ?? defaultScheduler)
            .flatMapLatest { observable in
                observable.toArray().map(\.count).map { arrayCount in
                    arrayCount < unStableCount
                }
            }
    }
    
    /// 将可观察数组的元素转换为指定的类型
    /// - Parameter type: 指定转换类型
    /// - Returns: 新的数组序列
    func compactConvertTo<T>(_ type: T.Type) -> Observable<[T]> where Self.Element: Sequence  {
        asObservable()
            .compactMap { sequence in
                sequence.compactMap { arrayElement in
                    arrayElement as? T
                }
            }
    }
    
    func concatMapCompletable(_ selector: @escaping (Self.Element) -> Completable) -> Completable {
        asObservable()
            .concatMap(selector)
            .asCompletable()
    }
    
    func flatMapLatest<Source: InfallibleType>(_ source: Source) -> Observable<Source.Element> {
        asObservable()
            .flatMapLatest { _ in source }
    }
    
    var completed: Completable {
        asObservable()
            .ignoreElements()
            .asCompletable()
    }
    
    var once: Observable<Element> {
        asObservable()
            .take(1)
    }
    
    /// 用于重新订阅事件 | 如: .retry(when: button.rx.tap.triggered)
    /// Tips: 配合.trackError使用的时候, 注意要把.trackError放在.retry(when:)的前面
    var triggered: (Observable<Error>) -> Observable<Element> {
        {
            $0.flatMapLatest { _ in
                asObservable().take(1)
            }
        }
    }
    
    @discardableResult
    func then<Object: AnyObject>(with object: Object, blockByError: Bool = false, _ nextStep: @escaping (Object, Error?) -> Void) -> Disposable {
        asObservable()
            .ignoreElements()
            .asCompletable()
            .subscribe {
                [weak object] event in
                guard let object else { return }
                switch event {
                case .completed:
                    nextStep(object, nil)
                case .error(let error):
                    if !blockByError {
                        nextStep(object, error)
                    }
                }
            }
    }
    
    /// 序列结束时回调Closure
    /// - Parameters:
    ///   - blockByError: 发生Error时是否继续执行下一步
    ///   - nextStep: 下一步执行的Closure
    @discardableResult
    func then(blockByError: Bool = false, _ nextStep: @escaping (Error?) -> Void) -> Disposable {
        asObservable()
            .ignoreElements()
            .asCompletable()
            .subscribe { event in
                switch event {
                case .completed:
                    nextStep(nil)
                case .error(let error):
                    if !blockByError {
                        nextStep(error)
                    }
                }
            }
    }
    
    var observable: Observable<Element> {
        asObservable()
    }
    
    var optionalElement: Observable<Element?> {
        asObservable()
            .map { $0 }
    }
    
    var anyElement: Observable<Any> {
        asObservable()
            .map { $0 }
    }
}

// MARK: - Observable of Collection
extension ObservableConvertibleType where Element: Collection {
    
    func removeDuplicates<Value>(for keyPath: KeyPath<Element.Element, Value>) -> Observable<[Element.Element]> where Value: Equatable {
        asObservable().map { collection in
            collection.removeDuplicates(for: keyPath)
        }
    }
    
    /// Emit nil if the collection is empty
    var filledOrNil: Observable<Element?> {
        asObservable().map(\.filledOrNil)
    }
}

// MARK: - Observable of OptionalType
extension ObservableConvertibleType where Element: OptionalType {
    
    func or(_ validElement: Element.Wrapped) -> Observable<Element.Wrapped> {
        asObservable()
            .map { optionalElement in
                optionalElement.optionalValue ?? validElement
            }
    }
    
    var unwrapped: Observable<Element.Wrapped> {
        asObservable().compactMap(\.optionalValue)
    }
}

extension ObservableConvertibleType where Element == String? {
    var orEmpty: Observable<String> {
        asObservable()
            .map(\.orEmpty)
    }
}

extension ObservableConvertibleType where Element == Int {
    
    var isNotEmpty: Observable<Bool> {
        isEmpty.map { isEmpty in !isEmpty }
    }
    
    var isEmpty: Observable<Bool> {
        asObservable()
            .map { $0 <= 0 }
    }
}

extension ObservableType {
    
    func asOptional<T>(_ type: T.Type) -> Observable<T?> {
        map { element in element as? T }
    }
    
    func `as`<T>(_ type: T.Type) -> Observable<T> {
        map { element in
            if let valid = element as? T {
                return valid
            }
            throw "类型转换失败"
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
	
	/// 用于蓝牙搜索等长时间操作
	var isProcessing: Driver<Bool> {
		asObservable().materialize()
			.map { event in
				switch event {
					case .next: return true
					default: return false
				}
			}
			.startWith(true)
			.distinctUntilChanged()
			.asDriver(onErrorJustReturn: false)
	}
	
	func repeatWhen<O: ObservableType>(_ notifier: O) -> Observable<Element> {
		notifier.map { _ in }
			.startWith(())
			.flatMap { _ -> Observable<Element> in
				self.asObservable()
			}
	}
}

infix operator <-> : DefaultPrecedence

#if os(iOS)
func <-> <Base>(textInput: TextInput<Base>, relay: BehaviorRelay<String>) -> Disposable {
    let bindToProperty = relay.bind(to: textInput.text)
    let bindToRelay = textInput.text.subscribe {
        [weak input = textInput.base] _ in
        /**
         In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
         value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
         The can be reproed easily if replace bottom code with
         
         if nonMarkedTextValue != relay.value {
            relay.accept(nonMarkedTextValue ?? "")
         }

         and you hit "Done" button on keyboard.
         */
        if let input, let unmarkedText = input.unmarkedText, unmarkedText != relay.value {
            relay.accept(unmarkedText)
        }
        
    } onCompleted: {
        bindToProperty.dispose()
    }
    
    return Disposables.create(bindToProperty, bindToRelay)
}
#endif

func <-> <T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    if T.self == String.self {
#if DEBUG && !os(macOS)
        fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to relay.\n" +
            "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
            "REMEDY: Just use `textField <-> relay` instead of `textField.rx.text <-> relay`.\n" +
            "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
            )
#endif
    }

    let bindToProperty = relay.bind(to: property)
    let bindToRelay = property.subscribe(onNext: relay.accept, onCompleted: bindToProperty.dispose)
    return Disposables.create(bindToProperty, bindToRelay)
}
