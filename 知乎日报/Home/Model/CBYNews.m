//
//  CBYNews.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/15.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYNews.h"
#import "MJExtension.h"
@implementation CBYNews
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"index" : @"id"};
}

- (NSString *)description{
    return [NSString stringWithFormat:@"图片网址:%@\n, 话题:%@\n, id:%@", self.image, self.title, self.index];
}

- (BOOL)isMultipic{
    return _multipic ? YES : NO;
}

- (NSString *)imageStr{
    return [self.images firstObject];
}
@end
