//
//  CBYShareModel.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYShareModel.h"

@implementation CBYShareModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _icon = dict[@"icon"];
        _title = dict[@"title"];
    }
    return self;
}

+ (instancetype)initWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)shareModels{
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share" ofType:@"plist"]];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
        CBYShareModel *model = [CBYShareModel initWithDict:dict];
        [tmpArray addObject:model];
    }
    return tmpArray;
}
@end
