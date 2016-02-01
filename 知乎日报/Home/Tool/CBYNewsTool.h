//
//  CBYNewsTool.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/20.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
typedef void(^CBYNewsToolBlock)(id obj);
typedef void(^CBYNewsFailureBlock)(NSError *error);

@class CBYNewsData, CBYThemeDetail;
@interface CBYNewsTool : NSObject
@property (nonatomic, strong) CBYNewsData *data;
@property (nonatomic, strong) CBYThemeDetail *detail;

/**
 *  从沙盒中加载数据时手动设置data与detail
 */
+ (void)setData:(CBYNewsData *)data;
+ (void)setDetail:(CBYThemeDetail *)detail;

+ (void)getNewsDateWith:(NSString *)date success:(CBYNewsToolBlock)success failure:(CBYNewsFailureBlock)failure;
+ (void)getThemeDetailWith:(NSNumber *)index success:(CBYNewsToolBlock)success failure:(CBYNewsFailureBlock)failure;

+ (BOOL)isTheFirstNewsWithIndex:(NSNumber *)index;
+ (BOOL)isTheLastNewsWithIndex:(NSNumber *)index;
+ (NSNumber *)getNextNewsIndexWithIndex:(NSNumber *)index;
+ (NSNumber *)getLastNewsIndexWithIndex:(NSNumber *)index;
@end
