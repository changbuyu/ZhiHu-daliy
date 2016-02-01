//
//  CBYEditor.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/17.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYEditor.h"
#import "MJExtension.h"
@implementation CBYEditor
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"index" : @"id"};
}
@end
