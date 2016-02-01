//
//  CBYHomeController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/11.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYHomeController.h"
#import "CBYMainController.h"
#import "CBYHomePageController.h"
#import "CBYOtherPageController.h"
#import "CBYLeftController.h"
#import "CBYTheme.h"
#import "MMDrawerController.h"
#import "CBYLoginView.h"
#import "UIImageView+WebCache.h"
#import "CBYHttpTool.h"
@interface CBYHomeController ()
@property (nonatomic, strong) CBYHomePageController *homePage;
@property (nonatomic, strong) CBYMainController *main;
@property (nonatomic, strong) NSArray *others;
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, weak) CBYLoginView *login;
//用于标记第一个控制器是否被使用
@property (nonatomic, assign, getter = isUsed) BOOL used;
//判断当前页是否首页
@property (nonatomic, assign, getter = isHome) BOOL home;
@end

@implementation CBYHomeController

#pragma mark ---- 懒加载
- (CBYHomePageController *)homePage{
    if (!_homePage) {
        _homePage = [[CBYHomePageController alloc] init];
        _homePage.view.frame = self.view.bounds;
        [self addChildViewController:_homePage];
    }
    return _homePage;
}

- (NSArray *)others{
    if (!_others) {
        CBYOtherPageController *first = [[CBYOtherPageController alloc] init];
        [self addChildViewController:first];
        CBYOtherPageController *second = [[CBYOtherPageController alloc] init];
        [self addChildViewController:second];
        _others = @[first, second];
    }
    return _others;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //取消tableView的自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CBYMainController *main = (CBYMainController *)[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[0];
    self.main = main;
    
    [self.view addSubview:self.homePage.view];

    [self addLoginImage];
    [self changeController];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)addLoginImage{
    CBYLoginView *view = [[CBYLoginView alloc] initWithFrame:self.view.bounds];
    
    //获取数据
    [CBYHttpTool get:@"http://news-at.zhihu.com/api/4/start-image/1080*1776" parameters:nil success:^(id json) {
        NSString *imgStr = json[@"img"];
        [view.imageView sd_setImageWithURL:[NSURL URLWithString:imgStr]];
        view.copyright.text = json[@"text"];
    } failure:^(NSError *error) {
    }];

    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    [UIView animateWithDuration:3.0 animations:^{
        view.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}


- (void)changeController{
    //1.拿到左边的controller
    CBYLeftController *left = self.main.left;
    left.block = ^(CBYTheme *theme){
        /**
         *  默认选择第一个cell时将home设为yes;
         */
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.home = YES;
        });
        if ([theme.name isEqualToString:@"首页"]) {
            if (self.isHome) {
                [self.main closeDrawerAnimated:YES completion:nil];
            }else{
                [self viewChangeToView:self.homePage.view];
                self.home = YES;
            }
        }else{
            self.home = NO;
            CBYOtherPageController *other;
            if (self.isUsed) {
                other = [self.others firstObject];
                self.used = NO;
            }else{
                other = [self.others lastObject];
                self.used = YES;
            }
            [self viewChangeToView:other.view];
            other.theme = theme;
        }
    };
}

- (void)viewChangeToView:(UIView *)view{
//    [self.view addSubview:view];
//    [self.main closeDrawerAnimated:YES completion:^(BOOL finished) {
//        self.lastView = nil;
//        self.lastView = view;
//    }];
    view.alpha = 0.0;
    [self.view addSubview:view];
    [UIView animateWithDuration:0.25 animations:^{
        self.lastView.alpha = 0.0;
        view.alpha = 1.0;
        [self.main closeDrawerAnimated:YES completion:nil];
    } completion:^(BOOL finished) {
        [self.lastView removeFromSuperview];
        self.lastView = view;
    }];
}


@end
