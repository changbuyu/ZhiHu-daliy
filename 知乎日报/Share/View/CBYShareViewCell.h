//
//  CBYShareViewCell.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const reusedIdentifier;

@class CBYShareModel;
@interface CBYShareViewCell : UICollectionViewCell
@property (nonatomic, strong) CBYShareModel *shareModel;

+ (instancetype)shareViewCell:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end
