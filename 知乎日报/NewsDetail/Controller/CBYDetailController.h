//
//  CBYDetailController.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
typedef NS_ENUM(NSUInteger, CBYDetailOptions){
    CBYDetailOptionsPrevious,
    CBYDetailOptionsNext
};

@class CBYDetail, CBYDetailController;
@protocol CBYDetailControllerDelegate <NSObject>

- (void)detailController:(CBYDetailController *)detail options:(CBYDetailOptions)option;
- (void)detailController:(CBYDetailController *)detail imgURL:(NSString *)imgURL;
@end

@interface CBYDetailController : UIViewController
@property (nonatomic, assign) CGFloat delta;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, weak) id<CBYDetailControllerDelegate> delegate;


- (void)loadDetail:(CBYDetail *)detail css:(NSString *)css;
@end
