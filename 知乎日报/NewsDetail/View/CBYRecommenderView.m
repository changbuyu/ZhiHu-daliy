//
//  CBYRecommenderView.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/24.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYRecommenderView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
static NSString *const ID = @"editor";
static const CGFloat kRecommenderAvatarMargin = 20;
static const CGFloat kAvatarViewWH = 30;

@interface CBYAvatarView : UIImageView
@property (nonatomic, copy) NSString *avatar;
@end

@implementation CBYAvatarView
- (instancetype)init{
    if (self = [super init]) {
        self.layer.cornerRadius = kAvatarViewWH * 0.5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setAvatar:(NSString *)avatar{
    _avatar = avatar;
    [self sd_setImageWithURL:[NSURL URLWithString:avatar]];
}
@end


@interface CBYRecommenderView ()
@property (weak, nonatomic) UILabel *titleLabel;
@property (nonatomic, weak) UIView *divide;
@property (nonatomic, strong) NSMutableArray *iconViews;
@end

@implementation CBYRecommenderView

- (NSMutableArray *)iconViews{
    if (!_iconViews) {
        _iconViews = [NSMutableArray array];
    }
    return _iconViews;
}

- (instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor = CBYCOLOR(237, 237, 237);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"推荐者";
        titleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *divide = [[UIView alloc] init];
        divide.backgroundColor = [UIColor blackColor];
        divide.alpha = 0.3;
        [self addSubview:divide];
        self.divide = divide;
    }
    return self;
}

- (void)setRecommenders:(NSArray *)recommenders{
    _recommenders = recommenders;
    NSInteger count = recommenders.count;
    for (int i = 0; i < count; i++) {
        CBYAvatarView *iconView = [[CBYAvatarView alloc] init];
        [self addSubview:iconView];
        [self.iconViews addObject:iconView];
        iconView.avatar = recommenders[i][@"avatar"];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(15);
    }];
    
    __block UIView *leftView = self.titleLabel;
    if (self.recommenders.count) {
        [self.iconViews enumerateObjectsUsingBlock:^(CBYAvatarView *obj, NSUInteger idx, BOOL * stop) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(kAvatarViewWH);
                make.centerY.equalTo(self.titleLabel);
                make.left.equalTo(leftView.mas_right).with.offset(kRecommenderAvatarMargin);
            }];
            leftView = obj;
        }];
    }
    
    [self.divide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self).with.offset(0.5);
    }];
}

@end
