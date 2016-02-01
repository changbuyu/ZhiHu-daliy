//
//  CBYNavBar.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/25.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
@class CBYNavBar;

@protocol CBYNavBarDelegate <NSObject>
@optional
- (void)navBar:(CBYNavBar *)navbar;
@end

@interface CBYNavBar : UIView
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) id<CBYNavBarDelegate> delegate;

- (void)dataDidStartLoad;
- (void)dataDidFinishLoad:(NSString *)title;
@end
