import UIKit

// 字符串移除不需要的字符
let notAllowedCharacterSet = CharacterSet(charactersIn: "9876543210").inverted
var input = "1.23456**()()0000"
input.unicodeScalars.removeAll { scalar in
	notAllowedCharacterSet.contains(scalar)
}
print(input)
