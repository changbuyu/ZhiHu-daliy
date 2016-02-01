//
//  CBYPubilc.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/25.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

#define CBYCOLOR(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//随机颜色
#define CBYRANDOMCOLOR [UIColor colorWithRed:arc4random_uniform(254)/255.0 green:arc4random_uniform(254)/255.0 blue:arc4random_uniform(254)/255.0 alpha:1]

//屏幕宽度
#define CBYSCREENW [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define CBYSCREENH [UIScreen mainScreen].bounds.size.height
//通知中心
#define CBYNOTICENTER [NSNotificationCenter defaultCenter]

// 日志输出
#ifdef DEBUG
#define CBYLog(...) NSLog(__VA_ARGS__)
#else
#define CBYLog(...)
#endif

// 字体大小
#define CBYTEXTFONT [UIFont systemFontOfSize:14]

UIKIT_EXTERN const NSTimeInterval CBYAnimationDuration;

UIKIT_EXTERN const CGFloat CBYNavigationBarHeight;
UIKIT_EXTERN const CGFloat CBYTopViewHeight;
UIKIT_EXTERN const CGFloat CBYTopImageViewHeight;
UIKIT_EXTERN const CGFloat CBYStatusBarHeight;
UIKIT_EXTERN const CGFloat CBYToolbarHeight;
UIKIT_EXTERN const CGFloat CBYShareViewMarginX;

UIKIT_EXTERN NSString *const CBYNavigationgBarNotification;
UIKIT_EXTERN NSString *const CBYChangeThemeNotification;
UIKIT_EXTERN NSString *const CBYShareButtonNotification;
