//
//  CBYShareButton.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//
#define CBYBUTTONFONT [UIFont boldSystemFontOfSize:10]
#import "CBYShareButton.h"
#import "CBYShareModel.h"
#import "Masonry.h"
static const CGFloat kButtonWidth = 50;

@interface CBYShareButton()
@property (weak, nonatomic)  UIButton *button;
@property (weak, nonatomic)  UILabel *label;

@end


@implementation CBYShareButton

- (instancetype)init{
    if (self = [super init]) {
        UIButton *button = [[UIButton alloc] init];
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        self.button = button;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = CBYBUTTONFONT;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.width.and.height.mas_equalTo(kButtonWidth);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom);
        make.bottom.and.centerX.equalTo(self);
    }];
}

- (void)setModel:(CBYShareModel *)model{
    _model = model;
    [self.button setBackgroundImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    self.label.text = model.title;
}

- (void)buttonClick{
    [CBYNOTICENTER postNotificationName:CBYShareButtonNotification object:nil userInfo:@{@"model" : self.model}];
}
@end
