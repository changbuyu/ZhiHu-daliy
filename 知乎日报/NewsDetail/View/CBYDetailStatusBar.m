//
//  CBYDetailStatusBar.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/19.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYDetailStatusBar.h"
#import "CBYDetailController.h"
@interface CBYDetailStatusBar()
@property (nonatomic, strong) id target;
@end

@implementation CBYDetailStatusBar

- (instancetype)init{
    if (self = [super init]) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addobserverToTarget:(id)target{
    self.target = target;
    CBYDetailController *vc = (CBYDetailController *)target;
    [vc addObserver:self forKeyPath:@"delta" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(CBYDetailController *)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (self.isShow) return;
    CGFloat offset = CBYTopViewHeight - CBYNavigationBarHeight - CBYStatusBarHeight;
    if (object.delta > offset) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        self.hidden = NO;
    }else{
        self.hidden = YES;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
//    NSLog(@"%@>>>%p", object.observationInfo, self);
}

//- (void)setShow:(BOOL)show{
//    _show = show;
//    if (show) {
//        self.hidden = NO;
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    }
//}

- (void)dealloc{
    [self.target removeObserver:self forKeyPath:@"delta"];
}
@end
