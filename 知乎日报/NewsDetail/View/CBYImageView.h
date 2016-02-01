//
//  CBYImageView.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/23.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
@interface CBYImageView : UIView
@property (nonatomic, copy) NSString *imgURL;

+ (CBYImageView *)showViewWith:(NSString *)imgURL view:(UIView *)superView;
- (void)showImageWithView:(UIView *)superView;

@end
