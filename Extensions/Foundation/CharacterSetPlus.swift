//
//  CharacterSetPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/5/12.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation

extension CharacterSet {
	
	/// 阿拉伯数字
	static let arabicNumbers = CharacterSet(charactersIn: "0123456789")
	
	#if DEBUG
	
	/// 获取字符集内所有的字符数组
	/// 注意：由于字符集非常庞大，尤其在使用 <#inverted#> 属性获取翻转后的字符集的时候不要使用此属性
	/// 否则会卡死线程
	var characters: [Character] {
		var result: [Int] = []
		var plane = 0
		for (i, w) in bitmapRepresentation.enumerated() {
			let k = i % 0x2001
			if k == 0x2000 {
				plane = Int(w) << 13
				continue
			}
			let base = (plane + k) << 3
			for j in 0 ..< 8 where w & 1 << j != 0 {
				result.append(base + j)
			}
		}
		return result.compactMap(UnicodeScalar.init).map(Character.init)
	}
	// 常用字符集
	/*
	let sets: [CharacterSet] = [
		.whitespaces, // 19个
		.newlines, // 7个
		.whitespacesAndNewlines, // 26个
		.decimalDigits, // 650个  不止 0...9, 还有一大堆其他文字的数字形式
		.punctuationCharacters, // 798个, 标点符号
		.symbols, // 7564个 包括Emoji表情的各种奇怪符号
		
		.urlUserAllowed,
		.urlPasswordAllowed, // 77个, 上面这俩家伙一样
		.urlHostAllowed, // 80个, 比上面两个多了:[]三个字符: ["!", "$", "&", "\'", "(", ")", "*", "+", ",", "-", ".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "=", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "]", "_", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "~"]
		.urlPathAllowed, // 79个, 比urlHostAllowed多了/@少了;[]
		.urlQueryAllowed, // 81个, 比urlHostAllowed多了/?@少了[]
		.urlFragmentAllowed // 81个, url片段, 同urlQueryAllowed
	]
	*/
	#endif
}
