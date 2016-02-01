//
//  CBYItemGroup.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/28.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYItemGroup : NSObject
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;

@property (nonatomic, strong) NSArray *items;
@end
