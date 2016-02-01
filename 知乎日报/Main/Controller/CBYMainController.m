//
//  CBYMainController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/11.
//  Copyright © 2016年 CBY. All rights reserved.
//


#import "CBYMainController.h"
#import "CBYLeftController.h"
#import "CBYHomeController.h"
#import "CBYNavController.h"
@interface CBYMainController ()
@property (nonatomic, weak) CBYHomeController *home;

@end

@implementation CBYMainController

- (CBYLeftController *)left{
    if (!_left) {
        _left = [[CBYLeftController alloc] init];
        _left.view.frame = [UIScreen mainScreen].bounds;
    }
    return _left;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加左边的控制器
    self.leftDrawerViewController = self.left;
    //添加主页控制器
//    CBYNavController *nav = [[CBYNavController alloc] initWithRootViewController:[[CBYHomeController alloc] init]];
//    nav.navigationBar.hidden = YES;
    self.centerViewController = [[CBYHomeController alloc] init];

    //订阅导航条按钮的通知
    [CBYNOTICENTER addObserver:self selector:@selector(showLeftController) name:CBYNavigationgBarNotification object:nil];
    
    /**
     *  设置抽屉属性,宽度,显示与关闭手势,抽屉能否被拉升,以及交界处的阴影效果.
     */
    
    [self setMaximumLeftDrawerWidth:CBYSCREENW * 0.7];
    
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self setShouldStretchDrawer:NO];
    
    [self setShowsShadow:NO];
}


#pragma mark ---- 响应事件
- (void)showLeftController{
    [self toggleDrawerSide:MMDrawerSideLeft
                  animated:YES
                completion:nil];
}

- (void)dealloc{
    [CBYNOTICENTER removeObserver:self];
}
@end

