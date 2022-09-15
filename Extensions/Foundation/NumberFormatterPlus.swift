//
//  NumberFormatterPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/6/15.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

extension NumberFormatter {
	
    @Transient(venishAfter: .seconds(300))
    fileprivate static var sharedNumberFormatter = NumberFormatter.init
	
	public static var shared: NumberFormatter {
        sharedNumberFormatter.unsafelyUnwrapped.reset()
	}
	
	public static var spellout: NumberFormatter {
		shared.configure {
			$0.numberStyle = .spellOut
			$0.zeroSymbol = "零"
			$0.locale = .chineseSimplified
		}
	}
	
	/// 重置NumberFormatter
	@discardableResult
	private func reset() -> Self {
        /// 格式化样式
		numberStyle = .none
        /// 本地化
		locale = .current
        /// 字符串转成Number的时候是否生成NSDecimalNumber对象
		generatesDecimalNumbers = false
        /// 是否允许浮点数
        allowsFloats = true
        /// 小数点符号
        decimalSeparator = "."
        /// 是否总是显示小数点符号
        alwaysShowsDecimalSeparator = false
        /// 货币小数点符号
        currencyDecimalSeparator = "."
        /// 分组符号
        groupingSeparator = ","
        /// 分组大小
        groupingSize = 0
        /// 第二分组大小: Some locales allow the specification of another grouping size for larger numbers. For example, some locales may represent a number such as 61, 242, 378.46 (as in the United States) as 6,12,42,378.46. In this case, the secondary grouping size (covering the groups of digits furthest from the decimal point) is 2.
        secondaryGroupingSize = 0
        /// 是否使用分组符号
        usesGroupingSeparator = false
        /// 0的符号
        zeroSymbol = .none
        /// 非数字符号
        notANumberSymbol = "NaN"
        /// 正无穷符号
        positiveInfinitySymbol = "+∞"
        /// 负无穷符号
        negativeInfinitySymbol = "-∞"
        /// 正数前缀
        positivePrefix = ""
        /// 正数后缀
        positiveSuffix = ""
        /// 负数前缀
        negativePrefix = "-"
        /// 负数后缀
        negativeSuffix = ""
        /// 货币代码
        currencyCode = "USD"
        /// 货币符号
        currencySymbol = "$"
        /// 国际化货币符号
        internationalCurrencySymbol = "USD"
        /// 百分符号
        percentSymbol = "%"
        /// 千分符号
        perMillSymbol = "‰"
        /// 减号
        minusSign = "-"
        /// 加号
        plusSign = "+"
        /// 指数符号
        exponentSymbol = "E"
        /// 数字<->字符转换因数: 字符串->数字时, 这个值用作除数. 数字->字符串时, 这个值用作乘数 These operations allow the formatted values to be different from the values that a program manipulates internally.
        multiplier = .none
        /// 进位规则
        roundingMode = .halfEven
        roundingIncrement = NSNumber(0)
        /// 最小整数位
        minimumIntegerDigits = 1
        /// 最大整数位
        maximumIntegerDigits = 42
        /// 最小小数位
        minimumFractionDigits = 0
        /// 最大小数位
        maximumFractionDigits = 0
        /// 是否使用有效数字
        usesSignificantDigits = false
        /// 最小有效数字
        minimumSignificantDigits = -1
        /// 最大有效数字
        maximumSignificantDigits = -1
        /// 允许输入的最小值
        minimum = .none
        /// 允许的最大值
        maximum = .none
        /// 货币分组符号
        currencyGroupingSeparator = ","
        
//        formatterBehavior = .behavior10_4
//        negativeFormat = "#########################################0"
//        textAttributesForNegativeValues = .none
//        positiveFormat = "#########################################0"
//        textAttributesForPositiveValues = .none
//        textAttributesForZero = .none
//        nilSymbol = "\n"
//        textAttributesForNil = .none
//        textAttributesForNotANumber = .none
//        textAttributesForPositiveInfinity = .none
//        textAttributesForNegativeInfinity = .none
//        formatWidth = -1
//        paddingCharacter = " "
//        paddingPosition = .beforePrefix
//        isLenient = false
//        isPartialStringValidationEnabled = false
		return self
	}
}
