//
//  CBYSection.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYSection : NSObject
/** 图片Url */
@property (nonatomic, copy) NSString *thumbnail;
/** id */
@property (nonatomic, strong) NSNumber *index;
/** name */
@property (nonatomic, copy) NSString *name;
@end
