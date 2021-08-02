//
//  NSObject+Plus.m
//  Plus
//
//  Created by Major on 2021/8/2.
//

#import "NSObject+Plus.h"

@implementation NSObject (Plus)

+ (void)exchangeSelector:(SEL)original withSwizzled:(SEL)swizzled {
    Method originalMethod = class_getInstanceMethod(self, original);
    Method swizzledMethod = class_getInstanceMethod(self, swizzled);
    if (class_addMethod(self, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
