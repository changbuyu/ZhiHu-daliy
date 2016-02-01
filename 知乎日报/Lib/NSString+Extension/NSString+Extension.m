//
//  NSString+Extension.m
//  QQ1
//
//  Created by 常布雨 on 14/11/14.
//  Copyright © 2015年 ioslearning. All rights reserved.
//

#import "NSString+Extension.h"
#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

@implementation NSString (Extension)
- (CGSize) sizeWithFontSize : (CGFloat)fontSize andMaxSize : (CGSize) maxSize
{
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

- (CGSize) sizeWithFontSize:(CGFloat)fontSize{
    return [self sizeWithFontSize:fontSize andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

- (CGSize) sizeWithFontSize:(CGFloat)fontSize andMaxX:(CGFloat)maxX{
    return [self sizeWithFontSize:fontSize andMaxSize:CGSizeMake(maxX, MAXFLOAT)];
}
- (CGSize) sizeWithFontSize:(CGFloat)fontSize andMaxY:(CGFloat)maxY{
    return [self sizeWithFontSize:fontSize andMaxSize:CGSizeMake(MAXFLOAT, maxY)];
}
#pragma mark ---- emoji
+ (NSString *)emojiWithIntCode:(NSInteger)intCode {
    NSInteger symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

- (NSString *)emoji
{
    return [NSString emojiWithStringCode:self];
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode
{
    char *charCode = (char *)stringCode.UTF8String;
    NSInteger intCode = strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:intCode];
}

// 判断是否是 emoji表情
- (BOOL)isEmoji
{
    BOOL returnValue = NO;
    
    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }
    
    return returnValue;
}

#pragma mark ---- 计算文件大小
- (NSUInteger)fileSize{
    NSFileManager *manager = [NSFileManager defaultManager];
 
    BOOL isDirectory = NO;
    BOOL isExists = [manager fileExistsAtPath:self isDirectory:&isDirectory];
    
    if (isExists == NO) return 0;
    
    if (isDirectory) {
        NSArray *subpaths = [manager subpathsAtPath:self];
        NSUInteger fileSize = 0;
        
        for (NSString *subpath in subpaths) {
            NSString *fullpath = [self stringByAppendingPathComponent:subpath];
            BOOL directory = NO;
            [manager fileExistsAtPath:fullpath isDirectory:&directory];
            if (directory == NO) {
                fileSize += [[manager attributesOfItemAtPath:fullpath error:nil][NSFileSize] integerValue];

            }
        }
        NSLog(@"%.1f", fileSize/1000/1000.0);
         return fileSize;
    }else{
        return [[manager attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    }
    return 0;
}
/**
 *  根据秒返回几分几秒 */
+ (NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time{
    
    int minute = (int)time / 60;
    int second = (int)time % 60;
    
    if (second > 9) { //2:10
        return [NSString stringWithFormat:@"%d:%d",minute,second];
    }
    
    //2:09
    return [NSString stringWithFormat:@"%d:0%d",minute,second];
}

/**根据日期(20160117)返回(01月17日 星期天) */
+ (NSString *)getDateAndWeekdayWithString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MM月dd日 EEEE"];
    return  [dateFormatter stringFromDate:date];
}

/**根据日期(20160117)返回(20160116) */
+ (NSString *)yesterDayDateWith:(NSString *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *old = [formatter dateFromString:date];
    NSDate *new = [NSDate dateWithTimeInterval: - 60 * 60 * 24 sinceDate:old];
    return [formatter stringFromDate:new];
}

/**将制定日期转化为年月日(20160117) */
+ (NSString *)getYearMonthAndDayWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter stringFromDate:date];
}
@end
