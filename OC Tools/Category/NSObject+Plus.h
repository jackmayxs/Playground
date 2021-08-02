//
//  NSObject+Plus.h
//  Plus
//
//  Created by Major on 2021/8/2.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Plus)

/// 方法交换
/// @param original 原方法
/// @param swizzled 交换方法
+ (void)exchangeSelector:(SEL)original withSwizzled:(SEL)swizzled;
@end

NS_ASSUME_NONNULL_END
