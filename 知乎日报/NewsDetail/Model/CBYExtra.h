//
//  CBYExtra.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/20.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYExtra : NSObject
@property (nonatomic, strong) NSNumber *post_reasons;
/** 长评论 */
@property (nonatomic, strong) NSNumber *long_comments;
/** 点赞数 */
@property (nonatomic, strong) NSNumber *popularity;
/** 普通评论 */
@property (nonatomic, strong) NSNumber *normal_comments;
/** 评论数 */
@property (nonatomic, strong) NSNumber *comments;
/** 短评论 */
@property (nonatomic, strong) NSNumber *short_comments;
@end
