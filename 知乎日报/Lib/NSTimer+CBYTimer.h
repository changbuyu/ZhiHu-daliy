//
//  NSTimer+CBYTimer.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/15.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CBYTimer)
+ (NSTimer *)by_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+ (NSTimer *)by_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
//暂停
-(void)pauseTimer;
//开始
-(void)resumeTimer;
//循环时间
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
