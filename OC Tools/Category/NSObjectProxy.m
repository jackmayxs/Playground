//
//  NSObjectProxy.m
//  OC Tools
//
//  Created by Choi on 2021/8/9.
//

#import "NSObjectProxy.h"

@interface NSObjectProxy ()
@property (nonatomic, weak) id target;
@end

@implementation NSObjectProxy

+ (instancetype)proxyWithTarget:(id)target {
	NSObjectProxy *proxy = [NSObjectProxy alloc];
	proxy.target = target;
	return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
	return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	[invocation invokeWithTarget:self.target];
}

@end
