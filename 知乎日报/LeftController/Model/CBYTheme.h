//
//  CBYTheme.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/11.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYTheme : NSObject
/** 图片地址 */
@property (nonatomic, copy) NSString *thumbnail;
/** 主题名 */
@property (nonatomic, copy) NSString *name;
/** id */
@property (nonatomic, strong) NSNumber *index;
/** color */
@property (nonatomic, strong) NSNumber *color;
@end
