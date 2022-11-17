//
//  DataPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/8.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension Optional where Wrapped == Data {
    var orEmpty: Data {
        self ?? Data()
    }
}

extension Data {
    
    private func hex(_ byte: Element) -> String {
        /// %02hhx: Lower cased
        String(format: "%02hhX", byte)
    }
    
    /// 2进制转16进制字符串
    var hexString: String {
        reversed().map(hex).joined()
    }
    
	var cfData: CFData {
		self as CFData
	}
	
	/// 转换为图片尺寸
	var imageSize: CGSize {
		guard let source = CGImageSourceCreateWithData(cfData, .none) else { return .zero }
		guard let image = CGImageSourceCreateImageAtIndex(source, 0, .none) else { return .zero }
		return CGSize(width: image.width, height: image.height)
	}
}
