//
//  CBYDetail.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYDetail.h"
#import "MJExtension.h"

@implementation CBYDetail
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"index" : @"id"};
}
@end
