//
//  NSObjectProxy.h
//  OC Tools
//
//  Created by Choi on 2021/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObjectProxy : NSProxy

/// 创建代理对象
/// @param target 被代理的对象
+ (instancetype)proxyWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
