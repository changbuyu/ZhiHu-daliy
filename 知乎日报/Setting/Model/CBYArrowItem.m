//
//  CBYArrowItem.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/28.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYArrowItem.h"

@implementation CBYArrowItem
- (instancetype)initIcon:(NSString *)icon destination:(Class)destination title:(NSString *)title{
    if (self = [super initIcon:icon title:title]) {
        self.destination = destination;
    }
    return self;
}

- (instancetype)initDestination:(id)destination title:(NSString *)title{
    return [self initIcon:nil destination:destination title:title];
}
@end
