import UIKit

/// 事件协议
protocol Event: Hashable { }

/// 状态类
class State<E: Event> {
	weak var stateMachine: StateMachine<E>?
	func trigger(event: E) { }
	func enter() {
		stateMachine?.currentState = self
	}
	func exit() { }
}

/// 状态机
class StateMachine<E: Event> {
	typealias MachineState = State<E>
	
	var currentState: MachineState
	private var states: [MachineState] = []
	init(initialState: MachineState) {
		currentState = initialState
	}
	func setupStates(_ _states: [MachineState]) {
		states = _states
		states.forEach {
			$0.stateMachine = self
		}
	}
	func trigger(event: E) {
		currentState.trigger(event: event)
	}
	func enter(_ stateClass: AnyClass) {
		states.forEach {
			if type(of: $0) == stateClass {
				$0.enter()
			}
		}
	}
}

/// 事件
enum RoleEvent: Event {
	case clickRunButton
	case clickWalkButton
}

/// 状态子类
class RunState: State<RoleEvent> {
	override func trigger(event: RoleEvent) {
		super.trigger(event: event)
		
		switch event {
			case .clickRunButton:
				break
			case .clickWalkButton:
				exit()
				stateMachine?.enter(WalkState.self)
		}
	}
	override func enter() {
		super.enter()
		print("==run enter==")
	}
	override func exit() {
		super.exit()
		print("==run exit==")
	}
}

class WalkState: State<RoleEvent> {
	override func trigger(event: RoleEvent) {
		super.trigger(event: event)
		
		switch event {
			case .clickRunButton:
				exit()
				stateMachine?.enter(RunState.self)
			case .clickWalkButton:
				break
		}
	}
	override func enter() {
		super.enter()
		print("==walk enter==")
	}
	override func exit() {
		super.exit()
		print("==walk exit==")
	}
}

/// 应用
func initialStateMachine() {
	let run = RunState()
	let walk = WalkState()
	let machine = StateMachine(initialState: run)
	machine.setupStates([run, walk])
	
	machine.trigger(event: .clickWalkButton)
	machine.trigger(event: .clickRunButton)
}

initialStateMachine()

// MARK: - __________ 函数式实现 __________
public typealias ExecutionBlock = () -> Void

public struct Transition<State, Event> {
	public let event: Event
	public let source: State
	public let destination: State
	
	let preAction: ExecutionBlock?
	let postAction: ExecutionBlock?
	
	public init(with event: Event,
				from: State,
				to: State,
				preBlock: ExecutionBlock?,
				postBlock: ExecutionBlock?) {
		self.event = event
		self.source = from
		self.destination = to
		self.preAction = preBlock
		self.postAction = postBlock
	}
	
	func executePreAction() {
		preAction?()
	}
	
	func executePostAction() {
		postAction?()
	}
}

class StateMachine2<State, Event> where Event: Hashable {
	
	public var currentState: State {
		workingQueue.sync {
			internalCurrentState
		}
	}
	
	private var internalCurrentState: State
	private let lockQueue: DispatchQueue
	private let workingQueue: DispatchQueue
	private let callbackQueue: DispatchQueue
	
	public init(initialState: State, callbackQueue: DispatchQueue? = nil) {
		internalCurrentState = initialState
		lockQueue = DispatchQueue(label: "com.statemachine.queue.lock")
		workingQueue = DispatchQueue(label: "com.statemachine.queue.working")
		self.callbackQueue = callbackQueue ?? .main
	}
	
	private var transitionByEvent: [Event: [Transition<State, Event>]] = [:]
}

// 原文链接:https://juejin.cn/post/7011430610942033956
