//
//  CBYNavController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYNavController.h"
#import "CBYLoginController.h"
@interface CBYNavController ()<UIGestureRecognizerDelegate>

@end

@implementation CBYNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取系统代理
    id target = self.interactivePopGestureRecognizer.delegate;
    //创建全屏滑动手势,调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *recognize = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];

    //设置代理
    recognize.delegate = self;
    //给导航控制器添加手势
    [self.view addGestureRecognizer:recognize];
    //禁用系统手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
}

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

@end
