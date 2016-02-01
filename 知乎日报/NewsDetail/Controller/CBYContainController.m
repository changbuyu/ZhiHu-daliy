//
//  CBYContainController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/24.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYContainController.h"
#import "CBYDetailController.h"
#import "CBYToolbar.h"
#import "CBYDetailStatusBar.h"
#import "CBYNewsTool.h"
#import "MBProgressHUD+MJ.h"
#import "CBYDetailTool.h"
#import "CBYDetail.h"
#import "CBYImageView.h"
#import "CBYShareController.h"
#import "CBYCommentsController.h"
@interface CBYContainController ()<CBYToolbarDelegate, CBYDetailControllerDelegate>
@property (nonatomic, strong) CBYDetailController *detailController;
@property (nonatomic, strong) CBYDetailStatusBar *statusBar;
@property (nonatomic, strong) CBYToolbar *toolbar;
@property (nonatomic, assign) BOOL oldStatus;
/** 详情 */
@property (nonatomic, strong) CBYDetail *detail;
@end

@implementation CBYContainController

- (CBYDetailController *)detailController{
    if (!_detailController) {
        _detailController = [[CBYDetailController alloc] init];
        _detailController.delegate = self;
        [self addChildViewController:_detailController];
    }
    return _detailController;
}

- (CBYDetailStatusBar *)statusBar{
    if (!_statusBar) {
        _statusBar = [[CBYDetailStatusBar alloc] init];
        _statusBar.frame = self.view.bounds;
        _statusBar.height = CBYStatusBarHeight;
    }
    return _statusBar;
}

- (CBYToolbar *)toolbar{
    if (!_toolbar) {
        _toolbar = [[CBYToolbar alloc] init];
        _toolbar.frame = self.view.bounds;
        _toolbar.y = self.view.height - CBYToolbarHeight;
        _toolbar.height = CBYToolbarHeight;
        _toolbar.delegate = self;
        
        [_toolbar addButtonWithName:@"News_Navigation_Arrow" highImage:@"News_Navigation_Arrow_Highlight" selectedImage:nil disabledImage:nil type:CBYToolbarButtonTypeBack];
        [_toolbar addButtonWithName:@"News_Navigation_Next" highImage:@"News_Navigation_Next_Highlight" selectedImage:nil disabledImage:@"News_Navigation_Unnext" type:CBYToolbarButtonTypeNext];
        [_toolbar addButtonWithName:@"News_Navigation_Vote" highImage:nil selectedImage:@"News_Navigation_Voted" disabledImage:nil type:CBYToolbarButtonTypeAttitude];
        [_toolbar addButtonWithName:@"News_Navigation_Share" highImage:@"News_Navigation_Share_Highlight" selectedImage:nil disabledImage:nil type:CBYToolbarButtonTypeShare];
        [_toolbar addButtonWithName:@"News_Navigation_Comment" highImage:@"News_Navigation_Comment_Highlight" selectedImage:nil disabledImage:nil type:CBYToolbarButtonTypeComment];
    }
    return _toolbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.oldStatus = YES;
    
    [self.view addSubview:self.detailController.view];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.statusBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.statusBar.hidden = self.oldStatus;
    if (!self.oldStatus) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.statusBar.isShow) {
        self.statusBar.hidden = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //用于标标记之前的状态
    self.oldStatus = self.statusBar.hidden;
    self.statusBar.hidden = YES;
}



- (void)setIndex:(NSNumber *)index{
    _index = index;
    self.detailController.index = index;
    [self.statusBar addobserverToTarget:self.detailController];
    self.toolbar.index = index;
    [self updateWithUrl:index];
}

//加载数据
- (void)updateWithUrl:(NSNumber *)index{
    
    [CBYDetailTool getDetailWithURLIndex:index success:^(id obj, NSString *css){
        CBYDetail *detail = (CBYDetail *)obj;
        self.detail = detail;
        [self.detailController loadDetail:detail css:css];
        if (!detail.image) {
            self.statusBar.show = YES;
        }else{
            self.statusBar.show = NO;
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    [self addChildViewController:self.detailController];
    [self.view insertSubview:self.detailController.view belowSubview:self.toolbar];
    [self.detailController loadDetail:detail css:css];
    }];

}

#pragma mark --- 工具条
- (void)toolBar:(CBYToolbar *)toolbar buttonType:(CBYToolbarButtonType)type{
    switch (type) {
        case CBYToolbarButtonTypeBack:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case CBYToolbarButtonTypeNext:
            [self gotoNextNews];
            break;
            
        case CBYToolbarButtonTypeAttitude:
            CBYLog(@"CBYToolbarButtonTypeAttitude");
            break;
            
        case CBYToolbarButtonTypeShare:{
            CBYShareController *share = [[CBYShareController alloc] init];
            [share showAboveView:[UIApplication sharedApplication].keyWindow];
            [self addChildViewController:share];
        }
            break;
            
        case CBYToolbarButtonTypeComment:{
            CBYCommentsController *comments = [[CBYCommentsController alloc] init];
            comments.index = self.index;
            [self.navigationController pushViewController:comments animated:YES];
        }
            break;
    }
}

- (void)gotoNextNews{
    [self resetAttitudeButton];
    if (![CBYNewsTool isTheLastNewsWithIndex:self.index]) {
        NSNumber *index = [CBYNewsTool getNextNewsIndexWithIndex:self.index];
        [self showDetailWithIndex:index next:YES];
        [self hiddenStatusbar];
    }else{
        [MBProgressHUD showError:@"已经是最后一篇了"];
    }
}

- (void)gotoPreviousNews{
    [self resetAttitudeButton];
    if (![CBYNewsTool isTheFirstNewsWithIndex:self.index]) {
        NSNumber *index = [CBYNewsTool getLastNewsIndexWithIndex:self.index];
        [self showDetailWithIndex:index next:NO];
        [self hiddenStatusbar];
    }else{
        [MBProgressHUD showError:@"已经是第一篇了"];
    }
}

- (void)hiddenStatusbar{
    if (self.detail.image) {
        self.statusBar.hidden = YES;
    }else{
        self.statusBar.hidden = NO;
    }
}

- (void)showDetailWithIndex:(NSNumber *)index next:(BOOL)next{
    
    [UIView animateWithDuration:CBYAnimationDuration animations:^{
        CGFloat offset = 0;
        if (next) {
            offset = - CBYSCREENH;
        }else{
            offset = CBYSCREENH;
        }
        self.detailController.view.transform = CGAffineTransformMakeTranslation(0, offset);
    } completion:^(BOOL finished) {
        [self.detailController.view removeFromSuperview];
        [self.detailController removeFromParentViewController];
        self.detailController = nil;
        self.index = index;
    }];
}

- (void)resetAttitudeButton{
    if (self.toolbar.attitudeButton.selected) {
        self.toolbar.attitudeButton.selected = NO;
        self.toolbar.oldCounts = nil;
        self.toolbar.attitudeLabel.textColor = [UIColor grayColor];
    }
}

#pragma mark ---- 代理方法
- (void)detailController:(CBYDetailController *)detail options:(CBYDetailOptions)option{
    switch (option) {
        case CBYDetailOptionsPrevious:
            [self gotoPreviousNews];
            break;
            
        case CBYDetailOptionsNext:
            [self gotoNextNews];
            break;
    }
}

- (void)detailController:(CBYDetailController *)detail imgURL:(NSString *)imgURL{
    CBYImageView *view = [CBYImageView showViewWith:imgURL view:self.view];
    [view showImageWithView:self.view];
}
@end
