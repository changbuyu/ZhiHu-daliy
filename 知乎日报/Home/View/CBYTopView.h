//
//  CBYTopView.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/13.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
@class CBYContainController;

typedef void(^CBYTopViewCellDidSelectedBlock)(CBYContainController * url);

@interface CBYTopView : UIView
@property (nonatomic, strong) NSArray *top_stroies;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) CBYTopViewCellDidSelectedBlock block;

- (void)addTimer;
@end
