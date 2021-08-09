//
//  NewViewController.m
//  OC Tools
//
//  Created by Choi on 2021/8/9.
//

#import "NewViewController.h"
#import "NSObject+Plus.h"

@interface NewViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation NewViewController

- (NSTimer *)timer {
	if (!_timer || !_timer.valid) {
		_timer = [NSTimer timerWithTimeInterval:1.2 target:self.proxy selector:@selector(tickTock) userInfo:nil repeats:YES];
	}
	return _timer;
}

- (void)tickTock {
	NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.timer fire];
	[NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
	[self.timer invalidate];
	NSLog(@"销毁");
}

@end
