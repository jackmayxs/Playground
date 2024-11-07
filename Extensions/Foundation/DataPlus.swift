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
    
    var indexRange: ClosedRange<Data.Index> {
        lowerBound...upperBound
    }
    
    /// 合并字节变动数组 | 如果是连续的字节变动则合并
    /// - Parameters:
    ///   - lhs: 字节变动数组
    ///   - rhs: 新的字节变动对象
    /// - Returns: 合并后的字节变动数组
    static func <--(changedBytesArray: [ChangedBytes], nextChangedBytes: ChangedBytes) -> [ChangedBytes] {
        /// 临时字节变化数组拷贝
        var tempResults = changedBytesArray
        /// 取出上一次字节变动模型 | 如果为空,说明数组为空,将右侧字节变化包装进数组并返回
        guard var lastChangedBytes = tempResults.popLast() else {
            return [nextChangedBytes]
        }
        /// 如果新的字节变动的下限等于上一次字节变动的上线+1, 说明是连续的字节变动
        if nextChangedBytes.lowerBound == lastChangedBytes.upperBound + 1 {
            /// 更新上限
            lastChangedBytes.upperBound = nextChangedBytes.upperBound
            /// 重新添加回数组
            tempResults.append(lastChangedBytes)
        }
        /// 否则不是连续的字节变动
        else {
            /// 重新添加回数组
            tempResults.append(lastChangedBytes)
            /// 并拼接新字节变动对象
            tempResults.append(nextChangedBytes)
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
    
    var fileExtension: String? {
        switch mimeType {
        case "image/jpeg":
            "jpeg"
        case "image/png":
            "png"
        case "image/gif":
            "gif"
        case "image/tiff":
            "tiff"
        case "application/pdf":
            "pdf"
        case "application/vnd":
            "vnd"
        case "text/plain":
            "txt"
        default:
            nil
        }
    }
}

extension Data {
    enum DataError: Error {
        case overFlow
    }
    enum ByteOrder {
        case bigEndian
        case littleEndian
    }
}

extension Data {
    
    var rawBytes: String {
        map(\.string).joined(separator: "|")
    }
    
    func jsonString(_ options: JSONSerialization.WritingOptions = []) -> String? {
        guard let jsonObject else { return nil }
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    var jsonObject: Any? {
        try? JSONSerialization.jsonObject(with: self)
    }
    
    var int: Int {
        binaryInteger(Int.self).orZero
    }
    
    var int64: Int64 {
        binaryInteger(Int64.self).orZero
    }
    
    var int32: Int32 {
        binaryInteger(Int32.self).orZero
    }
    
    var int16: Int16 {
        binaryInteger(Int16.self).orZero
    }
    
    var int8: Int8 {
        binaryInteger(Int8.self).orZero
    }
    
    var uint: UInt {
        binaryInteger(UInt.self).orZero
    }
    
    var uint64: UInt64 {
        binaryInteger(UInt64.self).orZero
    }
    
    var uint32: UInt32 {
        binaryInteger(UInt32.self).orZero
    }
    
    var uint16: UInt16 {
        binaryInteger(UInt16.self).orZero
    }
    
    var uint8: UInt8 {
        binaryInteger(UInt8.self).orZero
    }
    
    /// 比较相同数量的二进制对象, 返回变化的字节数组
    /// 注: 如果是连续的字节变化会进行合并操作
    /// - Parameter newData: 新二进制
    /// - Returns: 变化的数组,带变化的索引
    /// 实例: [0,0,0,0,0,0,0,0,0,0] -> [255,255,255,0,0,255,255,0,0,255]
    /// 结果: [changed: 0 - 2: [255, 255, 255], changed: 5 - 6: [255, 255], changed: 9 - 9: [255]
    func changedBytes(newData: Data) -> [ChangedBytes] {
        /// 字节数较小的二进制
        let minData = count < newData.count ? self : newData
        /// 临时二进制变化数组
        var changedBytesArray = [ChangedBytes].empty
        /// 遍历较小个数的二进制的每个字节
        for byteIndex in minData.indices {
            /// 旧字节
            let oldByte = self[byteIndex]
            /// 新字节
            let newByte = newData[byteIndex]
            /// 确保字节有变动; 否则继续循环
            guard newByte != oldByte else { continue }
            /// 取出上一段变动的字节模型 | 如果不为空(数组中有之前的字节变动)
            if var lastChangedBytes = changedBytesArray.popLast() {
                /// 上一次的字节变动有值
                let nextUpperBound = lastChangedBytes.upperBound + 1
                /// 如果当前的Index等于上一次变动的上限+1(连续的字节变动)
                if byteIndex == nextUpperBound {
                    /// 更新上一次字节变动的上限 | 并添加新的字节 | 重新添加回数组
                    lastChangedBytes.upperBound = nextUpperBound
                    lastChangedBytes.bytes.append(newByte)
                    changedBytesArray.append(lastChangedBytes)
                }
                /// 否则为不连续的字节变动
                else {
                    /// 将之前移除的字节变动重新添加回数组元素
                    changedBytesArray.append(lastChangedBytes)
                    /// 创建新值并添加到数组
                    let newItem = ChangedBytes(lowerBound: byteIndex, upperBound: byteIndex, bytes: [newByte])
                    changedBytesArray.append(newItem)
                }
            }
            /// 数组中没有之前的字节变动(第一个字节变动)
            else {
                /// 将字节放入数组
                let bytes = [newByte]
                /// 初始化一个新的ChangedBytes对象
                let newItem = ChangedBytes(lowerBound: byteIndex, upperBound: byteIndex, bytes: bytes)
                /// 并添加到数组
                changedBytesArray.append(newItem)
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
    
    var utf8String: String {
        String(data: self, encoding: .utf8).orEmpty
    }
    
    /// 2进制转16进制字符串
    var hexString: String {
        reduce(into: "") { hex, nextByte in
            /// 注: %02hhx: 小写字母
            hex += String(format: "%02hhX", nextByte)
        }
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
    
    /// 显示二进制大小: KB, MB...
    var countDescription: String {
        ByteCountFormatter.string(fromByteCount: count.int64, countStyle: .file)
    }
}
