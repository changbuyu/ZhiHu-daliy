//
//  CBYLoginController.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
typedef NS_ENUM(NSInteger, CBYLoginControllerShowType) {
    CBYLoginControllerShowTypeModal,
    CBYLoginControllerShowTypepush
};

@interface CBYLoginController : UIViewController
@property (nonatomic, assign) CBYLoginControllerShowType showType;
@end
