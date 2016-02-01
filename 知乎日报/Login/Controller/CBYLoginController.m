//
//  CBYLoginController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYLoginController.h"
#import "CBYNavBar.h"
@interface CBYLoginController ()<CBYNavBarDelegate>
@property (nonatomic, weak) CBYNavBar *bar;
@end

@implementation CBYLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupNavBar{
    CGRect frame = self.view.bounds;
    frame.size.height = CBYNavigationBarHeight;
    CBYNavBar *bar = [[CBYNavBar alloc] initWithFrame:frame];
    bar.backgroundColor = CBYCOLOR(230, 230, 230);
    [bar.button setImage:[UIImage imageNamed:@"Login_Arrow"] forState:UIControlStateNormal];
    [bar.button setImage:[UIImage imageNamed:@"Login_Arrow_Highlight"] forState:UIControlStateHighlighted];
    bar.titleLabel.text = @"登陆";
    bar.titleLabel.textAlignment = NSTextAlignmentCenter;
    bar.titleLabel.textColor = [UIColor blackColor];
    bar.delegate = self;
    [self.view addSubview:bar];
    self.bar = bar;
}

//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    self.bar.button.frame = CGRectMake(0, 23, 21, 21);
//    
//    self.bar.titleLabel.centerX = self.bar.centerX;
//    self.bar.titleLabel.centerY = self.bar.button.centerY;
//}

- (IBAction)sinaLogin {
}

- (IBAction)tencentLogin {
}

- (void)navBar:(CBYNavBar *)navbar{
    switch (self.showType) {
        case CBYLoginControllerShowTypeModal:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case CBYLoginControllerShowTypepush:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
    
}

@end
