//
//  CBYMainController.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/11.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
#import "MMDrawerController.h"


@class CBYLeftController;
@interface CBYMainController : MMDrawerController
@property (nonatomic, strong) CBYLeftController *left;
@end
