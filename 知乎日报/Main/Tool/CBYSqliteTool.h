//
//  CBYSqliteTool.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYSqliteTool : NSObject
+ (NSArray *)readDataWith:(NSDictionary *)dict;
+ (void)saveDataWith:(NSDictionary *)dict extraInfo:(id)info withName:(NSString *)name;
@end
