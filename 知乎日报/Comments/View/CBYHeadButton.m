//
//  CBYHeadButton.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/31.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYHeadButton.h"
#import "Masonry.h"
#import "CBYPubilc.h"
@interface CBYHeadButton ()
/** 分割线 */
@property (nonatomic, weak) UIView *divide;
@end

@implementation CBYHeadButton
- (void)setHighlighted:(BOOL)highlighted{
    
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.textLabel = label;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeCenter;
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UIView *divide = [[UIView alloc] init];
        divide.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:divide];
        self.divide = divide;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.bottom.equalTo(self);
        make.width.equalTo(self.mas_height).with.multipliedBy(1.5);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self.iconView.mas_left);
    }];
    
    [self.divide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(-0.5);
        make.height.mas_equalTo(1);
    }];
}


@end
