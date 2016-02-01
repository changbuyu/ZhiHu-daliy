//
//  CBYThemeDetail.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/17.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYThemeDetail.h"
#import "MJExtension.h"
#import "CBYNews.h"
#import "CBYEditor.h"
@implementation CBYThemeDetail
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"describe" : @"description"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"stories" : [CBYNews class], @"editors" : [CBYEditor class]};
}
@end
