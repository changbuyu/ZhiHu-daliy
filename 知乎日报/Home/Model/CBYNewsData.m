//
//  CBYNewsData.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/15.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYNewsData.h"
#import "MJExtension.h"
#import "CBYNews.h"
@implementation CBYNewsData
MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"stories" : [CBYNews class], @"top_stories" : [CBYNews class]};
}

@end
