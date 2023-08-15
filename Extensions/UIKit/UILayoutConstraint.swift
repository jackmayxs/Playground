//
//  UILayoutConstraint.swift
//  KnowLED
//
//  Created by Choi on 2023/8/15.
//

import UIKit

public struct UILayoutConstraint {
    let constant: Double
    let priority: UILayoutPriority
    init(constant: Double, priority: UILayoutPriority) {
        self.constant = constant
        self.priority = priority
    }
}

extension CGFloat {
    var uiLayoutConstraint: UILayoutConstraint {
        uiLayoutConstraint()
    }
    func uiLayoutConstraint(priority: UILayoutPriority = .required) -> UILayoutConstraint {
        UILayoutConstraint(constant: self, priority: priority)
    }
}

extension Double {
    var uiLayoutConstraint: UILayoutConstraint {
        uiLayoutConstraint()
    }
    func uiLayoutConstraint(priority: UILayoutPriority = .required) -> UILayoutConstraint {
        UILayoutConstraint(constant: self, priority: priority)
    }
}

extension Int {
    var uiLayoutConstraint: UILayoutConstraint {
        uiLayoutConstraint()
    }
    func uiLayoutConstraint(priority: UILayoutPriority = .required) -> UILayoutConstraint {
        UILayoutConstraint(constant: Double(self), priority: priority)
    }
}
