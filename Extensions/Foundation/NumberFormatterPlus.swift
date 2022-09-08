//
//  NumberFormatterPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/6/15.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

extension NumberFormatter {
	
	@Transient(venishAfter: 300)
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
		numberStyle = .none
		locale = .current
		generatesDecimalNumbers = false
		formatterBehavior = .behavior10_4
		negativeFormat = "#########################################0"
		textAttributesForNegativeValues = .none
		positiveFormat = "#########################################0"
		textAttributesForPositiveValues = .none
		allowsFloats = true
		decimalSeparator = "."
		alwaysShowsDecimalSeparator = false
		currencyDecimalSeparator = "."
		usesGroupingSeparator = false
		groupingSeparator = ","
		zeroSymbol = .none
		textAttributesForZero = .none
		nilSymbol = "\n"
		textAttributesForNil = .none
		notANumberSymbol = "NaN"
		textAttributesForNotANumber = .none
		positiveInfinitySymbol = "+∞"
		textAttributesForPositiveInfinity = .none
		negativeInfinitySymbol = "-∞"
		textAttributesForNegativeInfinity = .none
		positivePrefix = ""
		positiveSuffix = ""
		negativePrefix = "-"
		negativeSuffix = ""
		currencyCode = "USD"
		currencySymbol = "$"
		internationalCurrencySymbol = "USD"
		percentSymbol = "%"
		perMillSymbol = "‰"
		minusSign = "-"
		plusSign = "+"
		exponentSymbol = "E"
		groupingSize = 0
		secondaryGroupingSize = 0
		multiplier = .none
		formatWidth = -1
		paddingCharacter = " "
		paddingPosition = .beforePrefix
		roundingMode = .halfEven
		roundingIncrement = NSNumber(0)
		minimumIntegerDigits = 1
		maximumIntegerDigits = 42
		minimumFractionDigits = 0
		maximumFractionDigits = 0
		minimum = .none
		maximum = .none
		currencyGroupingSeparator = ","
		isLenient = false
		usesSignificantDigits = false
		minimumSignificantDigits = -1
		maximumSignificantDigits = -1
		isPartialStringValidationEnabled = false
		return self
	}
}
