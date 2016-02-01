//
//  CBYLoginView.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/16.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYLoginView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface CBYLoginView ()
@property (nonatomic, weak) UIImageView *loginView;
@end

@implementation CBYLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //登陆图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.backgroundColor = [UIColor blackColor];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        self.imageView = imageView;

        //登陆logo
        UIImageView *loginView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_Logo"]];
        [self addSubview:loginView];
        self.loginView = loginView;
        
        //图片版权
        UILabel *copyright = [[UILabel alloc] init];
        copyright.textAlignment = NSTextAlignmentCenter;
        copyright.textColor = [UIColor whiteColor];
        copyright.font = [UIFont systemFontOfSize:12];
        self.copyright = copyright;
        [self addSubview:copyright];
    }
    
        
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(45);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).with.offset(-40);
    }];
    
    [self.copyright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).with.offset(- 10);
    }];
    
    
}


@end
