//
//  CBYHttpTool.h
//  新浪微博
//
//  Created by 常布雨 on 15/12/20.
//  Copyright © 2015年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYHttpTool : NSObject
+ (void)get: (NSString *)url parameters:(NSDictionary *)dict success:(void(^)(id json))success failure: (void (^)(NSError *error))failure;

+ (void)post: (NSString *)url parameters:(NSDictionary *)dict success:(void(^)(id json))success failure: (void (^)(NSError *error))failure;

+ (void)post: (NSString *)url parameters:(NSDictionary *)dict constructingBody:(NSData *)data success:(void(^)(id json))success failure: (void (^)(NSError *error))failure;
@end
