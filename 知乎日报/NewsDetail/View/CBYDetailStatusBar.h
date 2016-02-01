//
//  CBYDetailStatusBar.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/19.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"

@interface CBYDetailStatusBar : UIView
@property (nonatomic, assign, getter = isShow) BOOL show;

- (void)addobserverToTarget:(id)target;
@end
