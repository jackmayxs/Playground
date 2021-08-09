//
//  NSObject+Plus.m
//  Plus
//
//  Created by Major on 2021/8/2.
//

#import "NSObject+Plus.h"

@implementation NSObject (Plus)

- (NSObjectProxy *)proxy {
	static void const * const proxyKey = @"NSObjectProxy";
	id object = objc_getAssociatedObject(self, proxyKey);
	if (object) {
		return object;
	} else {
		NSObjectProxy *proxy = [NSObjectProxy proxyWithTarget:self];
		objc_setAssociatedObject(self, proxyKey, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		return proxy;
	}
}

+ (void)exchangeSelector:(SEL)original withSwizzled:(SEL)swizzled {
	
    Method originalMethod = class_getInstanceMethod(self, original);
    Method swizzledMethod = class_getInstanceMethod(self, swizzled);
	
	IMP originalIMP = method_getImplementation(originalMethod);
	IMP swizzledIMP = method_getImplementation(swizzledMethod);
	
	const char *originalEncoding = method_getTypeEncoding(originalMethod);
	const char *swizzledEncoding = method_getTypeEncoding(swizzledMethod);
	
	// 如果原方法没有实现
	if (!originalMethod) {
		// 先用新的实现来，临时添加一个（这里忽略新实现也为空的情况，可以类似的处理）
		class_addMethod(self, original, swizzledIMP, swizzledEncoding);
		// 对 originalMethod 变量重新赋值
		originalMethod = class_getInstanceMethod(self, original);
		// 创建默认实现，可以进行一些日志收集之类的
		IMP defaultIMP = imp_implementationWithBlock(^(id self, SEL _cmd) {
			NSLog(@"一些默认实现...");
		});
		// 为originalMethod设置IMP
		method_setImplementation(originalMethod, defaultIMP);
	}
	
	// 添加成功即：原本没有 originalSelector，成功为子类添加了一个 originalSelector - swizzledMethod 的方法
    if (class_addMethod(self, original, swizzledIMP, swizzledEncoding)) {
		// 这里将原 swizzledIMP 替换为 originalIMP
        class_replaceMethod(self, swizzled, originalIMP, originalEncoding);
		NSLog(@"添加成功!");
    }
	// 已经存在原方法,直接交换方法实现
	else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
