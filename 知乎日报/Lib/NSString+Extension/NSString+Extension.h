//
//  NSString+Extension.h
//  QQ1
//
//  Created by 常布雨 on 14/11/14.
//  Copyright © 2015年 ioslearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(NSInteger)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;
/**
 *  根据文字内容计算size
 */
- (CGSize) sizeWithFontSize :(CGFloat)fontSize andMaxSize : (CGSize) maxSize;

- (CGSize) sizeWithFontSize:(CGFloat)fontSize;

- (CGSize) sizeWithFontSize:(CGFloat)fontSize andMaxX:(CGFloat)maxX;

- (CGSize) sizeWithFontSize:(CGFloat)fontSize andMaxY:(CGFloat)maxY;
/**
 *  根据文件路径计算大小
 */
- (NSUInteger)fileSize;
/**
 *  根据秒返回XX:XX
 */
+(NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time;

/**根据日期(20160117)返回(01月17日 星期天) */
+ (NSString *)getDateAndWeekdayWithString:(NSString *)dateString;

/**根据日期(20160117)返回(20160116) */
+ (NSString *)yesterDayDateWith:(NSString *)date;

/**将指定日期转化为年月日(20160117) */
+ (NSString *)getYearMonthAndDayWithDate:(NSDate *)date;
@end
