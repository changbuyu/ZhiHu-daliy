//
//  CBYArrowItem.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/28.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYItem.h"

@interface CBYArrowItem : CBYItem
@property (nonatomic, weak) Class destination;

- (instancetype)initIcon:(NSString *)icon destination:(Class)destination title:(NSString *)title;
- (instancetype)initDestination:(id)destination title:(NSString *)title;
@end
