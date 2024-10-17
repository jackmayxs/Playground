//
//  TypestateDesignPattern.swift
//  KnowLED
//
//  Created by Choi on 2024/9/27.
//
//  原文: https://swiftology.io/articles/typestate/
//  Swift Evolution:
//  https://github.com/apple/swift-evolution/blob/main/proposals/0390-noncopyable-structs-and-enums.md#working-around-the-generics-restrictions
//  https://gist.github.com/Alex-Ozun/9669bb1b02be1f63cb509ea859869c31#file-typestate-tesla-car-swift

import Foundation

enum Locked {}
enum Unlocked {}

/// 十字转门 | 地铁闸机
struct Turnstile<State>: ~Copyable {
    private(set) var coins: Int
    private init(coins: Int) {
        self.coins = coins
    }
}

extension Turnstile where State == Locked {
    init() {
        self.init(coins: 0)
    }
    consuming func insertCoin() -> Turnstile<Unlocked> {
        Turnstile<Unlocked>(coins: coins + 1)
    }
}

extension Turnstile where State == Unlocked {
    
    consuming func push() -> Turnstile<Locked> {
        Turnstile<Locked>(coins: coins)
    }
}

typealias LockedTurnstile = Turnstile<Locked>
typealias UnlockedTurnstile = Turnstile<Unlocked>

enum TurnstileState: ~Copyable {
    case locked(LockedTurnstile)
    case unlocked(UnlockedTurnstile)
    
    init() {
        self = .locked(Turnstile<Locked>())
    }
    
    mutating func coins() -> Int {
        let coins: Int
        switch consume self {
        case let .locked(locked):
            coins = locked.coins
            self = .locked(locked)
        case let .unlocked(unlocked):
            coins = unlocked.coins
            self = .unlocked(unlocked)
        }
        return coins
    }
    
    mutating func insertCoin() {
        switch consume self {
        case .locked(let locked):
            let unlocked = locked.insertCoin()
            self = .unlocked(unlocked)
        case .unlocked(let unlocked):
            self = .unlocked(unlocked)
        }
    }
    
    mutating func push() {
        switch consume self {
        case .locked(let locked):
            self = .locked(locked)
        case .unlocked(let unlocked):
            let locked = unlocked.push()
            self = .locked(locked)
        }
    }
}

func combinedInterface() {
    var turnstile = TurnstileState()
    turnstile.insertCoin() // unlocked
    turnstile.insertCoin() // does nothing
    turnstile.push() // locked
    turnstile.push() // does nothing
    print(turnstile.coins()) // 1
}

// Example of a non-deterministic transition
extension Turnstile where State == Locked {
    enum TransitionResult: ~Copyable {
        case locked(Turnstile<Locked>)
        case unlocked(Turnstile<Unlocked>)
    }
    
    consuming func tryInsertCoin(coinDiameter: Decimal) -> TransitionResult {
        if coinDiameter <= 5 {
            return .unlocked(Turnstile<Unlocked>(coins: coins + 1))
        } else {
            return .locked(self)
        }
    }
}

extension TurnstileState {
    mutating func tryInsertCoin(coinDiameter: Decimal) {
        switch consume self {
        case let .locked(locked):
            let result = locked.tryInsertCoin(coinDiameter: coinDiameter)
            switch consume result {
            case let .locked(locked):
                self = .locked(locked)
            case let .unlocked(unlocked):
                self = .unlocked(unlocked)
            }
        case let .unlocked(unlocked):
            self = .unlocked(unlocked)
        }
    }
}

func nonDeterministicTransition() {
    var turnstile = TurnstileState()
    turnstile.tryInsertCoin(coinDiameter: 10) // still locked
    turnstile.tryInsertCoin(coinDiameter: 2) // unlocked
}
