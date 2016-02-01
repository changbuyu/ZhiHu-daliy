//
//  CBYNews.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/15.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYNews : NSObject
/** 轮播区的图片 */
@property (nonatomic, copy) NSString *image;
/** cell区的图片,存在数组里的字符串 */
@property (nonatomic, strong) NSArray *images;
/** cell区的图片 */
@property (nonatomic, strong) NSString *imageStr;
/** newsID */
@property (nonatomic, strong) NSNumber *index;
/** type */
@property (nonatomic, strong) NSNumber *type;
/** ga_prefix */
@property (nonatomic, copy) NSString *ga_prefix;
/** 话题 */
@property (nonatomic, copy) NSString *title;
/** 是否多图 */
@property (nonatomic, assign, getter = isMultipic) BOOL multipic;
@end
