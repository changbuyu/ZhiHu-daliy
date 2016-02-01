//
//  CBYTopViewCell.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/13.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYTopViewCell.h"
#import "UIImageView+WebCache.h"
#import "CBYNews.h"
NSString *const CBYReusedID = @"item";

@interface CBYTopViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CBYTopViewCell
+ (instancetype)topViewCell:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    CBYTopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CBYReusedID forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CBYTopViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

- (void)setNews:(CBYNews *)news{
    _news = news;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:news.image] placeholderImage:[UIImage imageNamed:@"Field_Mask_Bg"]];
    self.titleLabel.text = news.title;
}

@end
