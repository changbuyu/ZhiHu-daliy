//
//  CBYShareView.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//
#define CBYSHAREFONT [UIFont boldSystemFontOfSize:12]
#import "CBYShareView.h"
#import "Masonry.h"
#import "CBYScrollView.h"
@interface CBYShareView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) CBYScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageController;
@property (nonatomic, weak) UIButton *collectButton;
@property (nonatomic, weak) UIButton *cancelButton;
@end


@implementation CBYShareView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = CBYSHAREFONT;
        label.text = @"分享这篇内容";
        [self addSubview:label];
        self.titleLabel = label;
        
        CGRect frame = self.bounds;
        frame.size.height = self.height * 0.5;
        CBYScrollView *scrollView = [[CBYScrollView alloc] initWithFrame:frame];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageController = [[UIPageControl alloc] init];
        pageController.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageController.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        pageController.numberOfPages = 2;
        [self addSubview:pageController];
        self.pageController = pageController;
        
        self.collectButton = [self addButtonWithTitle:@"收藏" type:CBYShareViewButtonTypeCollet];
        self.cancelButton = [self addButtonWithTitle:@"取消" type:CBYShareViewButtonTypeCancel];
        
    }
    return self;
}

- (UIButton *)addButtonWithTitle:(NSString *)title type:(CBYShareViewButtonType)type{
    UIButton *button = [[UIButton alloc] init];
    button.tag = type;
    button.titleLabel.font = CBYSHAREFONT;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"Browser_Button"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"Browser_Button_Highlight"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self);
        make.height.mas_equalTo(self.height * 0.1);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(self.height * 0.5);
    }];
    
    [self.pageController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).with.offset(self.height * 0.15);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(CBYShareViewMarginX);
        make.right.equalTo(self).with.offset(- CBYShareViewMarginX);
        make.top.equalTo(self.scrollView.mas_bottom).with.offset(self.height * 0.1);
        make.height.mas_equalTo(self.height * 0.1);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(CBYShareViewMarginX);
        make.right.equalTo(self).with.offset(- CBYShareViewMarginX);
        make.top.equalTo(self.collectButton.mas_bottom).with.offset(self.height * 0.05);
        make.height.mas_equalTo(self.height * 0.1);
    }];
}

#pragma mark --- 响应事件
- (void)buttonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(shareView:buttonType:)]) {
        [self.delegate shareView:self buttonType:sender.tag];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger count = scrollView.contentOffset.x / self.width + 0.5;
    self.pageController.currentPage = count;
}

@end
