//
//  CBYItem.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/28.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYItem.h"

@implementation CBYItem
- (instancetype)initIcon:(NSString *)icon title:(NSString *)title{
    if (self = [super init]) {
        self.icon = icon;
        self.title = title;
    }
    return self;
}

- (instancetype)initTitle:(NSString *)title{
    return [self initIcon:nil title:title];
}
@end
