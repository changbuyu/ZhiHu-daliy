//
//  CBYBottomBar.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/30.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const CBYBottomBarBackButton;

@class CBYBottomBar;
@protocol CBYBottomBarDelegate <NSObject>
@optional
- (void)bottomBar:(CBYBottomBar *)bottombar name:(NSString *)name;

@end

@interface CBYBottomBar : UIView
/** 代理 */
@property (nonatomic, weak) id<CBYBottomBarDelegate> delegate;
@end
