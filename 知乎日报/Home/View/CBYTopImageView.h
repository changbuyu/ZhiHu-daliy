//
//  CBYTopImageView.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/14.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"

@interface CBYTopImageView : UIImageView
@property (nonatomic, copy) NSString *thumbnail;

- (void)addObserveTo:(UIScrollView *)scrollView;
@end
