//
//  CBYComment.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/29.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYComment : NSObject
/** 作者 */
@property (nonatomic, copy) NSString *author;
/** 评论 */
@property (nonatomic, copy) NSString *content;
/** 头像地址 */
@property (nonatomic, copy) NSString *avatar;
/** 发表时间 */
@property (nonatomic, strong) NSNumber *time;
/** id */
@property (nonatomic, strong) NSNumber *index;
/** 点赞数 */
@property (nonatomic, strong) NSNumber *likes;
/** 被回复评论 */
@property (nonatomic, strong) CBYComment *reply_to;
/** 转化后的发表时间 */
@property (nonatomic, copy) NSString *timeStr;
@end
