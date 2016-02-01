//
//  CBYCommentTool.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/29.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYCommentTool.h"
#import "CBYComment.h"
#import "CBYHttpTool.h"
#import "MJExtension.h"

@implementation CBYCommentTool



+ (void)longCommentsWithIndex:(NSString *)index success:(CBYCommtentToolBlock)success{
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/long-comments", index];
    [CBYHttpTool get:url parameters:nil success:^(id json) {
        success([CBYComment mj_objectArrayWithKeyValuesArray:json[@"comments"]]);
    } failure:^(NSError *error) {
    }];

}

+ (void)shortCommentsWithIndex:(NSString *)index success:(CBYCommtentToolBlock)success{
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/short-comments", index];
    [CBYHttpTool get:url parameters:nil success:^(id json) {
         success([CBYComment mj_objectArrayWithKeyValuesArray:json[@"comments"]]);
    } failure:^(NSError *error) {
        
    }];

}


@end
