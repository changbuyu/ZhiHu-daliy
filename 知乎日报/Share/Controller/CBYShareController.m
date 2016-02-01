//
//  CBYShareController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/25.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYShareController.h"
#import "CBYShareView.h"
#import "UIView+Extension.h"
#import "CBYLoginController.h"
@interface CBYShareController ()<CBYShareViewDelegate>
@property (nonatomic, weak) UIButton *cover;
@property (nonatomic, weak) UIView *shareView;
@end

@implementation CBYShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addCoverButton];
    
    [self addShareView];
    
    [CBYNOTICENTER addObserver:self selector:@selector(shareButtonClick:) name:CBYShareButtonNotification object:nil];
}

- (void)addCoverButton{
    UIButton *cover = [[UIButton alloc] initWithFrame:self.view.bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [cover addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    self.cover = cover;
}

- (void)addShareView{
    CGRect frame = self.view.bounds;
    frame.size.height = self.view.height * 0.5;
    CBYShareView *share = [[CBYShareView alloc] initWithFrame:frame];
    share.y = CBYSCREENH;
    share.backgroundColor = CBYCOLOR(230, 230, 230);
    share.delegate = self;
    [self.view addSubview:share];
    self.shareView = share;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.shareView.height = CBYSCREENH * 0.5;
}

- (void)buttonClick{
    [UIView animateWithDuration:CBYAnimationDuration animations:^{
        self.cover.alpha = 0.0;
        self.shareView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)showAboveView:(UIView *)superView{
    [superView addSubview:self.view];
    [UIView animateWithDuration:CBYAnimationDuration animations:^{
        self.cover.alpha = 0.5f;
        self.shareView.transform = CGAffineTransformMakeTranslation(0, - CBYSCREENH * 0.5);
    }];
}

#pragma mark ---- 代理方法
- (void)shareView:(CBYShareView *)share buttonType:(CBYShareViewButtonType)type{
    switch (type) {
        case CBYShareViewButtonTypeCollet:{
            [self buttonClick];
            CBYLoginController *login = [[CBYLoginController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }
            break;
        
        case CBYShareViewButtonTypeCancel:
            [self buttonClick];
            break;
    }
}

#pragma mark ---- 响应事件
- (void)shareButtonClick:(NSNotification *)noti{
    CBYLog(@"%@", noti);
}

- (void)dealloc{
    [CBYNOTICENTER removeObserver:self];
}
@end
