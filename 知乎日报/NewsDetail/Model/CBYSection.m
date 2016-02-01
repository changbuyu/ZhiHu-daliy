//
//  CBYSection.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYSection.h"
#import "MJExtension.h"
@implementation CBYSection
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"index" : @"id"};
}
@end
