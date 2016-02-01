//
//  CBYTheme.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/11.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYTheme.h"
#import "MJExtension.h"
@implementation CBYTheme

MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"index" : @"id"};
}

- (NSString *)description{
    return [NSString stringWithFormat:@"图片网址:%@\n, 主题:%@\n, id:%@", self.thumbnail, self.name, self.index];
}
@end
