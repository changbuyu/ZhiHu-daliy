//
//  CBYDetailTopView.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYDetailTopView.h"
#import "Masonry.h"
#import "CBYDetail.h"
#import "UIImageView+WebCache.h"

static const CGFloat kTilteLabelMargin = 10.0;
static const CGFloat kSourceLabelMargin = 5.0;

@interface CBYDetailTopView ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *sourceLabel;
@end

@implementation CBYDetailTopView

- (instancetype)init{
    if (self = [super init]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.textColor = [UIColor whiteColor];
        sourceLabel.textAlignment = NSTextAlignmentRight;
        sourceLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
    }
    return self;
}

- (void)setDetail:(CBYDetail *)detail{
    _detail = detail;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:detail.image] placeholderImage:[UIImage imageNamed:@"Field_Mask_Bg"]];
    
    self.titleLabel.text = detail.title;
    
    self.sourceLabel.text = [NSString stringWithFormat:@"图片: %@", detail.image_source];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(- kTilteLabelMargin);
        make.left.equalTo(self.mas_left).with.offset(kTilteLabelMargin);
        make.bottom.equalTo(self.mas_bottom).with.offset(- kTilteLabelMargin * 2);
    }];
    
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(- kSourceLabelMargin * 2);
        make.bottom.equalTo(self.mas_bottom).with.offset(- kSourceLabelMargin);
    }];
}

@end
