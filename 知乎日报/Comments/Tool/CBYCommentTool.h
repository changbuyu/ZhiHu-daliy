//
//  CBYCommentTool.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/29.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CBYCommtentToolBlock)(NSArray *array);

@interface CBYCommentTool : NSObject
+ (void)longCommentsWithIndex:(NSString *)index success:(CBYCommtentToolBlock)success;

+ (void)shortCommentsWithIndex:(NSString *)index success:(CBYCommtentToolBlock)success;
@end
