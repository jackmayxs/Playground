//
//  FloatingPointPlus.swift
//  KnowLED
//
//  Created by Choi on 2024/9/5.
//

import Foundation

extension FloatingPoint {
    
    /// 实时创建的百分比范围, 尽量避免直接使用. 在常用的类型扩展里储存一份静态常量
    static var hotPercentRange: ClosedRange<Self> { 0...1 }
    
    /// 按照指定精度和进位规则进位
    /// - Parameters:
    ///   - roundingIncrement: 进位精度
    ///   - rule: 进位规则
    /// - Returns: 进位后的结果
    /// 这里的形参命名借用了NumberFormatter的同名属性, 具体作用在其reset()方法中的属性注释中有详细说明
    func rounded(_ roundingIncrement: Self, rule: FloatingPointRoundingRule) -> Self {
        roundingIncrement * (self / roundingIncrement).rounded(rule)
    }
}
