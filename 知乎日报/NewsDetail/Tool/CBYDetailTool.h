//
//  CBYDetailTool.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/20.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CBYDetailBlock)(id obj, NSString *css);

@interface CBYDetailTool : NSObject
+ (void)getDetailWithURLIndex:(NSNumber *)index success:(CBYDetailBlock)success;
+ (void)getExtraWithIndex:(NSNumber *)index success:(CBYDetailBlock)success;
@end
