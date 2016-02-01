//
//  CBYNavigationBar.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/13.
//  Copyright © 2016年 CBY. All rights reserved.
//
typedef void(^CBYScrollViewEndScrollBlock)();
#import "CBYPubilc.h"
#import "CBYTheme.h"

@interface CBYNavigationBar : UIView
@property (weak, nonatomic)  UIActivityIndicatorView *activityView;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) CBYTheme *theme;
@property (weak, nonatomic)  UIView *contentView;
@property (nonatomic, weak) UIView *statusView;
@property (nonatomic, assign) CGFloat totleOffset;
@property (nonatomic, assign) NSInteger index;
/** 最新的新闻的日期的前一天 */
@property (nonatomic, copy) NSString *newsDate;
/** 存放所有section的高度 */
@property (nonatomic, strong) NSMutableArray *offsets;

@property (nonatomic, assign, getter = isRefreshing) BOOL refreshing;
@property (nonatomic, copy) CBYScrollViewEndScrollBlock block;

- (void)addObserveToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action;
@end
