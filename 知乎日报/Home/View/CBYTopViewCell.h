//
//  CBYTopViewCell.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/13.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const CBYReusedID;

@class CBYNews;
@interface CBYTopViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) CBYNews *news;

+ (instancetype)topViewCell:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end
