//
//  CBYComment.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/29.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYComment.h"
#import "MJExtension.h"
@implementation CBYComment
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"index" : @"id"};
}
- (NSString *)description{
    return [NSString stringWithFormat:@"作者:%@\n 内容:%@\n re评论:%@", self.author, self.content, self.reply_to];
}

- (void)setTime:(NSNumber *)time{
    _time = time;
    NSDate *creat = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    _timeStr = [formatter stringFromDate:creat];
}
@end
