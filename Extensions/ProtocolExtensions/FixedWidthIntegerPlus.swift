//
//  FixedWidthIntegerPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import Foundation

extension FixedWidthInteger {
    
    /// 生成随机数
    static var random: Self {
        random(in: range)
    }
    
    /// 支持的范围
    static var range: ClosedRange<Self> {
        min...max
    }
    
    /// 二进制
    var data: Data {
        dataInBytes()
    }
    
    /// 转换为二进制
    /// - Parameters:
    ///   - byteCount: 占用字节数, 如不指定则使用自身默认占用的字节数
    ///   - byteOrder: 字节序, 默认为小字节序
    /// - Returns: 转换后的二进制对象(字节翻转过的数组: 从左到右为低位到高位排列)
    /// 加注: 默认为小字节序: 二进制从左往右为数字的二进制从低位(右侧)到高位(左侧)按字节依次填充
    func dataInBytes(_ preferredByteCount: Int? = nil, byteOrder: Data.ByteOrder = .littleEndian) -> Data {
        var copy = byteOrder == .bigEndian ? bigEndian : littleEndian
        let byteCount = preferredByteCount ?? bitWidth / 8
        return Data(bytes: &copy, count: byteCount)
    }
}
