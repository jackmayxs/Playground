//
//  DispatchQueuePlus.swift
//  KnowLED
//
//  Created by Choi on 2024/1/3.
//

import Dispatch

extension DispatchQueue {
    
    /// 获取指定队列 | 注: 只能在指定队列中的方法才能获取到队列
    static func getSpecificQueue<Q>(_ key: DispatchSpecificKey<ObjectReference<Q>>) -> Q? where Q: DispatchQueue {
        DispatchQueue.getSpecific(key: key).flatMap(\.object)
    }
}
