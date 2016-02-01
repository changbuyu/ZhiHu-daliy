//
//  CBYExtra.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/20.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYExtra.h"
#import "MJExtension.h"
@implementation CBYExtra
MJCodingImplementation

- (NSString *)description{
    return [NSString stringWithFormat:@"点赞:%@, 评论:%@",self.popularity, self.comments];
}
@end

