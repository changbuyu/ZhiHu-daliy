//
//  CBYToolbar.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"

typedef NS_ENUM(NSUInteger, CBYToolbarButtonType) {
    CBYToolbarButtonTypeBack,  //返回
    CBYToolbarButtonTypePrevious, //webview上一篇
    CBYToolbarButtonTypeForward, //webview下一篇
    CBYToolbarButtonTypeNext,  //下一篇
    CBYToolbarButtonTypeAttitude, //点赞
    CBYToolbarButtonTypeShare,  //转发
    CBYToolbarButtonTypeComment,  //评论
    CBYToolbarButtonTypeRefresh, //刷新
};

@class CBYToolbar;

@protocol CBYToolbarDelegate <NSObject>

@optional
- (void)toolBar:(CBYToolbar *)toolbar buttonType:(CBYToolbarButtonType)type;

@end

@interface CBYToolbar : UIView
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, weak) id<CBYToolbarDelegate> delegate;
@property (nonatomic, assign) BOOL canGoNext;
@property (nonatomic, assign) BOOL canGoPrevious;
@property (nonatomic, weak) UIButton *attitudeButton;
@property (nonatomic, copy) NSString *oldCounts;
@property (nonatomic, weak) UILabel *attitudeLabel;

- (void)addButtonWithName:(NSString *)imageName highImage:(NSString *)highImage selectedImage:(NSString *)selectedImage disabledImage:(NSString *)disabledImage type:(CBYToolbarButtonType)type;

@end
