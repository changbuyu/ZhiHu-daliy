//
//  CBYNavBar.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/25.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYNavBar.h"
@interface CBYNavBar ()
@property (nonatomic, weak) UIActivityIndicatorView *indicator;

@end

@implementation CBYNavBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.height = CBYNavigationBarHeight;
        self.backgroundColor = CBYCOLOR(24, 123, 200);
        //左边的button
        UIButton *button = [[UIButton alloc] init];
        button.adjustsImageWhenHighlighted = NO;
        [self addSubview:button];
        [button addTarget:self action:@selector(backToLastView) forControlEvents:UIControlEventTouchUpInside];
        self.button = button;
        //标题栏
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //菊花
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:indicator];
        self.indicator = indicator;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _button.frame = CGRectMake(10, 20, 44, 44);
    
    _titleLabel.y = _button.y;
    _titleLabel.x = CGRectGetMaxX(_button.frame);
    _titleLabel.width = CBYSCREENW * 0.7;
    _titleLabel.height = 44;
    
    _indicator.size = CGSizeMake(30, 30);
    _indicator.centerX = CBYSCREENW * 0.9;
    _indicator.centerY = _button.centerY;
}

- (void)dataDidStartLoad{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
}

- (void)dataDidFinishLoad:(NSString *)title{
    self.indicator.hidden = YES;
    self.titleLabel.text = title;
}

#pragma mark --- 响应事件
- (void)backToLastView{
    if ([self.delegate respondsToSelector:@selector(navBar:)]) {
        [self.delegate navBar:self];
    }
}
@end
