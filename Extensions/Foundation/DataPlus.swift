//
//  DataPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/8.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

public struct ChangedBytes: CustomStringConvertible {
    /// 字节在二进制中的索引
    var lowerBound: Data.Index
    /// 字节在二进制中的索引
    var upperBound: Data.Index
    /// 改动的字节数组
    var bytes: [Data.Element]
    
    public var description: String {
        "changed: \(lowerBound) - \(upperBound): \(bytes)"
    }
    
    static func <-- (lhs: [ChangedBytes], rhs: ChangedBytes) -> [ChangedBytes] {
        guard lhs.isNotEmpty else {
            return [rhs]
        }
        var tempResults = lhs
        guard var tempLast = lhs.last else { return lhs }
        if rhs.lowerBound == tempLast.upperBound + 1 {
            tempLast.upperBound = rhs.upperBound
            _ = tempResults.popLast()
            tempResults.append(tempLast)
        } else {
            tempResults.append(rhs)
        }
        return tempResults
    }
}

extension Optional where Wrapped == Data {
    var orEmpty: Data {
        self ?? Data()
    }
}

extension Data {
    
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
        ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
    
    var fileExtension: String {
        switch mimeType {
        case "image/jpeg":
            return "jpeg"
        case "image/png":
            return "png"
        case "image/gif":
            return "gif"
        case "image/tiff":
            return "tiff"
        case "application/pdf":
            return "pdf"
        case "application/vnd":
            return "vnd"
        case "text/plain":
            return "txt"
        default:
            return "uknown"
        }
    }
}

enum DataError: Error {
    case overFlow
}

extension Data {
    
    var int: Int {
        binaryInteger(Int.self) ?? 0
    }
    
    var int64: Int64 {
        binaryInteger(Int64.self) ?? 0
    }
    
    var int32: Int32 {
        binaryInteger(Int32.self) ?? 0
    }
    
    var int16: Int16 {
        binaryInteger(Int16.self) ?? 0
    }
    
    var int8: Int8 {
        binaryInteger(Int8.self) ?? 0
    }
    
    var uint: UInt {
        binaryInteger(UInt.self) ?? 0
    }
    
    var uint64: UInt64 {
        binaryInteger(UInt64.self) ?? 0
    }
    
    var uint32: UInt32 {
        binaryInteger(UInt32.self) ?? 0
    }
    
    var uint16: UInt16 {
        binaryInteger(UInt16.self) ?? 0
    }
    
    var uint8: UInt8 {
        binaryInteger(UInt8.self) ?? 0
    }
    
    /// 比较相同数量的二进制对象, 返回变化的字节数组
    /// - Parameter newData: 新数组
    /// - Returns: 变化的数组,带变化的索引
    func changedBytes(newData: Data) -> [ChangedBytes] {
        let count = Swift.min(self.count, newData.count)
        var changedBytesArray: [ChangedBytes] = []
        for i in 0 ..< count {
            let oldByte = self[i]
            let newByte = newData[i]
            if newByte != oldByte {
                guard var temp = changedBytesArray.last else {
                    let newItem = ChangedBytes(lowerBound: i, upperBound: i, bytes: [newByte])
                    changedBytesArray.append(newItem)
                    continue
                }
                let nextUpperBound = temp.upperBound + 1
                if i == nextUpperBound {
                    temp.upperBound = nextUpperBound
                    temp.bytes.append(newByte)
                    _ = changedBytesArray.popLast()
                    changedBytesArray.append(temp)
                } else {
                    let newItem = ChangedBytes(lowerBound: i, upperBound: i, bytes: [newByte])
                    changedBytesArray.append(newItem)
                }
            }
        }
        return changedBytesArray
    }
    
    func binaryInteger<T>(_ numberType: T.Type) -> T? where T: BinaryInteger {
        do {
            return try withUnsafeBytes { rawBufferPointer in
                guard count <= MemoryLayout<T>.size else {
                    throw DataError.overFlow
                }
                return rawBufferPointer.load(as: T.self)
            }
        } catch {
            return nil
        }
    }
    
    private func hex(_ byte: Element) -> String {
        /// %02hhx: Lower cased
        String(format: "%02hhX", byte)
    }
    
    var utf8String: String {
        String(data: self, encoding: .utf8).orEmpty
    }
    
    /// 2进制转16进制字符串
    var hexString: String {
        map(hex).joined()
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
