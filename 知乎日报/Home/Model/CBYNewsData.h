//
//  CBYNewsData.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/15.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBYNews;
@interface CBYNewsData : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) NSArray *top_stories;
@end
