//
//  CBYShareView.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
typedef NS_ENUM(NSInteger, CBYShareViewButtonType){
    CBYShareViewButtonTypeCollet,  //收藏
    CBYShareViewButtonTypeCancel   //取消
};

@class CBYShareView;
@protocol CBYShareViewDelegate <NSObject>
@optional
- (void)shareView:(CBYShareView *)share buttonType:(CBYShareViewButtonType)type;

@end

@interface CBYShareView : UIView
@property (nonatomic, weak) id<CBYShareViewDelegate> delegate;
@end
