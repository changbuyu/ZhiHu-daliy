//
//  CBYShareViewCell.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//
#define CBYCELLFONT [UIFont systemFontOfSize:10]

#import "CBYShareViewCell.h"
#import "UIView+Extension.h"
#import "CBYShareModel.h"
NSString *const reusedIdentifier = @"cell";

@interface CBYShareViewCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation CBYShareViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = CBYCELLFONT;
        label.textColor = [UIColor lightGrayColor];
        [self addSubview:label];
        self.titleLabel = label;
    }
    return self;
}


+ (instancetype)shareViewCell:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    CBYShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedIdentifier  forIndexPath:indexPath];
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.imageView.height = self.height * 0.8;
    
    self.titleLabel.frame = self.bounds;
    self.titleLabel.height = self.height * 0.2;
    self.titleLabel.y = self.imageView.height;
}

- (void)setShareModel:(CBYShareModel *)shareModel{
    _shareModel = shareModel;
    self.imageView.image = [UIImage imageNamed:shareModel.icon];
    self.titleLabel.text = shareModel.title;
}
@end
