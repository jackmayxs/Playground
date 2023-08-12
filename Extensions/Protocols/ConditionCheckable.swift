//
//  ConditionCheckable.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import Foundation

protocol ConditionCheckable {
    func matchOrNil(condition: (Self) -> Bool) -> Self?
}

extension ConditionCheckable {
    func matchOrNil(condition: (Self) -> Bool) -> Self? {
        if condition(self) {
            return self
        } else {
            return nil
        }
    }
    func matchCaseOrNil(case: Self) -> Self? where Self: Comparable {
        if self == `case` {
            return self
        } else {
            return nil
        }
    }
}

extension String: ConditionCheckable { }
