//
//  Snowflake.swift
//  KnowLED
//
//  Created by godox on 2024/9/15.
//

import UIKit
/// 雪花算法结构体，用于生成分布式唯一ID 在本地灯库生成时使用
/// 雪花算法生成的ID实际上是一个64位的长整数。这64位被分成几个部分：
/// 1、1位符号位：始终为0，保证ID是正数。
/// 2、41位时间戳：雪花算法的核心部分，它提供了一个长达约69年的唯一标识符生成能力。这个时间戳是基于一个自定义的起始时间（通常是算法设计或系统上线的时间）计算得出的毫秒数。
/// 3、10位工作机器ID
/// 4、12位序列号
/// 最终我们将这个64位长整数转换为十进制数时，它通常会产生一个18到19位的数字。具体位数取决于时间戳的大小。
struct Snowflake {
    /// 起始时间戳（毫秒），设置为 2024-09-15 01:42:54.657 UTC
        private static let twepoch: Int64 = 1726306974657
    
    /// 机器ID所占的位数
    private static let workerIdBits = 10
    
    /// 支持的最大机器ID，十位二进制最大结果为1023  -1：通常用所有位都是1的二进制数表示，然后左移十位[-1 << workerIdBits的结果：这会产生一个二进制数，其中最右边的 10 位是 0，其余位是 1]，在和原有的-1二进制为做异或操作
    private static let maxWorkerId = -1 ^ (-1 << workerIdBits)
    
    /// 序列号占的位数
    private static let sequenceBits = 12
    
    /// 机器ID向左移12位
    private static let workerIdShift = sequenceBits
    
    /// 时间戳向左移22位(10+12)
    private static let timestampLeftShift = sequenceBits + workerIdBits
    
    /// 生成序列的掩码，这里为4095 (0b111111111111=0xfff=4095)
    private static let sequenceMask: Int64 = -1 ^ (-1 << sequenceBits)
    
    /// 工作机器ID(0~1023)
    private static let workerId: Int64 = generateWorkerId()
    
    /// 毫秒内序列(0~4095)
    private static var sequence: Int64 = 0
    
    /// 上次生成ID的时间戳（毫秒）
    private static var lastTimestamp: Int64 = -1
    
    /// 生成工作机器ID
    /// - Returns: 返回一个0~1023之间的工作机器ID
    private static func generateWorkerId() -> Int64 {
        let deviceId = UIDevice.current.identifierForVendor ?? UUID()
        let hashValue = abs(deviceId.hashValue)
        return Int64(hashValue % (maxWorkerId + 1))
    }
    
    /// 生成下一个ID
    /// - Returns: 返回一个唯一的ID
    static func nextId() -> Int64 {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        var timestamp = currentTimestamp()
        
        if timestamp < lastTimestamp {
            // 处理时钟回拨
            timestamp = tilNextMillis(lastTimestamp)
        }
        
        if timestamp == lastTimestamp {
            // 同一毫秒内，序列号自增
            sequence = (sequence + 1) & sequenceMask
            if sequence == 0 {
                // 同一毫秒内序列数已经达到最大
                timestamp = tilNextMillis(lastTimestamp)
            }
        } else {
            // 不同毫秒内，序列号置为0
            sequence = 0
        }
        
        lastTimestamp = timestamp
        
        // 组合最终的ID
        return ((timestamp - twepoch) << timestampLeftShift) |
               (workerId << workerIdShift) |
               sequence
    }
    
    /// 阻塞到下一个毫秒，直到获得新的时间戳
    /// - Parameter lastTimestamp: 上次生成ID的时间戳
    /// - Returns: 返回新的时间戳
    private static func tilNextMillis(_ lastTimestamp: Int64) -> Int64 {
        var timestamp = currentTimestamp()
        while timestamp <= lastTimestamp {
            timestamp = currentTimestamp()
        }
        return timestamp
    }
    
    /// 获取当前时间戳（毫秒）
    /// - Returns: 返回当前时间戳
    private static func currentTimestamp() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
