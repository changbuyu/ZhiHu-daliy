//
//  CBYNocommentView.m
//  知乎日报
//
//  Created by 常布雨 on 16/2/1.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYNocommentView.h"
#import "Masonry.h"
#import "CBYPubilc.h"
@interface CBYNocommentView ()

@property (nonatomic, weak) UIImageView *imageView;
/** 分割线 */
@property (nonatomic, weak) UIView *divide;
@end

@implementation CBYNocommentView

- (instancetype)init{
    if (self = [super init]) {

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Comment_Empty"]];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
        label.text = @"暂时没有评论";
        [self addSubview:label];
        self.label = label;
        
        UIView *divide = [[UIView alloc] init];
        divide.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:divide];
        self.divide = divide;
        [self addAutoLayout];
    }
    return self;
}

- (void)addAutoLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(10);
    }];
    
    [self.divide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.equalTo(self);
        make.bottom.equalTo(self).with.offset(0.5);
        make.height.mas_equalTo(1);
    }];
}

@end
