//
//  CBYHttpTool.m
//  新浪微博
//
//  Created by 常布雨 on 15/12/20.
//  Copyright © 2015年 CBY. All rights reserved.
//

#import "CBYHttpTool.h"
#import "AFNetworking.h"
@implementation CBYHttpTool
+ (void)get: (NSString *)url parameters:(NSDictionary *)dict success:(void(^)(id json))success failure: (void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)post: (NSString *)url parameters:(NSDictionary *)dict success:(void(^)(id json))success failure: (void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)post: (NSString *)url parameters:(NSDictionary *)dict constructingBody:(NSData *)data success:(void(^)(id json))success failure: (void (^)(NSError *error))failure{
    
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
