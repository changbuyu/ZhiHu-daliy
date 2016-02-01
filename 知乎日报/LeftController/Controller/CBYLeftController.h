//
//  CBYLeftController.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/11.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
@class CBYTheme;
typedef void(^CBYLeftViewCellDidSelectedBlock)(CBYTheme *theme);
@interface CBYLeftController : UIViewController
@property (nonatomic, copy) CBYLeftViewCellDidSelectedBlock block;
@end
