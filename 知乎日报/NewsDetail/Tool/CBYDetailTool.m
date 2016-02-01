//
//  CBYDetailTool.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/20.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYDetailTool.h"
#import "CBYHttpTool.h"
#import "CBYDetail.h"
#import "MJExtension.h"
#import "CBYExtra.h"
#import "CBYSqliteTool.h"
@implementation CBYDetailTool
+ (void)getDetailWithURLIndex:(NSNumber *)index success:(CBYDetailBlock)success{
  
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = @"stories";
    dict[@"idstr"] = [NSString stringWithFormat:@"%@", index];
    NSArray *array = [CBYSqliteTool readDataWith:dict];
    
    if (array.count) {
        CBYDetail *detail = [CBYDetail mj_objectWithKeyValues:array[0]];
        NSString *css = array[1];
        success(detail, css);
    }else{
        [CBYHttpTool get:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@", index] parameters:nil success:^(id json) {
            CBYDetail *newDetail = [CBYDetail mj_objectWithKeyValues:json];
            NSString *newCss = [NSString stringWithContentsOfURL:[NSURL URLWithString:newDetail.css[0]] encoding:NSUTF8StringEncoding error:nil];
            success(newDetail, newCss);
            [CBYSqliteTool saveDataWith:json extraInfo:newCss withName:@"stories"];
            
        } failure:^(NSError *error) {
        
        }];
    }
}

+ (void)getExtraWithIndex:(NSNumber *)index success:(CBYDetailBlock)success{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = @"extra";
    dict[@"idstr"] = [NSString stringWithFormat:@"%@", index];
    NSArray *array = [CBYSqliteTool readDataWith:dict];
  
    [CBYHttpTool get:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%@",index] parameters:nil success:^(id json) {
        [CBYSqliteTool saveDataWith:json extraInfo:nil withName:@"extra"];
        CBYExtra *newExtra = [CBYExtra mj_objectWithKeyValues:json];
        success(newExtra, nil);
    } failure:^(NSError *error) {
        if (array.count) {
            CBYExtra *extra = [CBYExtra mj_objectWithKeyValues:array[0]];
            success(extra, nil);
        }
    }];
}
@end
