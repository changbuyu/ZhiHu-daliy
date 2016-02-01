//
//  CBYNewsTool.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/20.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYNewsTool.h"
#import "CBYHttpTool.h"
#import "CBYNewsData.h"
#import "CBYThemeDetail.h"
#import "MJExtension.h"
#import "CBYNews.h"
#import "CBYTheme.h"
@interface CBYNewsTool()
@property (nonatomic, strong) NSMutableArray *indexes;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end

static CBYNewsTool *tool;

@implementation CBYNewsTool

+ (void)initialize{
    [super initialize];
    [CBYNOTICENTER addObserver:self selector:@selector(changeTheme:) name:CBYChangeThemeNotification object:nil];
}

- (NSMutableArray *)indexes{
    if (!_indexes) {
        _indexes = [NSMutableArray array];
    }
    return _indexes;
}
/**
 *  用于保存不同的主题的新闻Id数组.
 */
- (NSMutableDictionary *)dictionary{
    if (!_dictionary) {
        _dictionary = [NSMutableDictionary dictionary];
    }
    return _dictionary;
}

+ (void)getNewsDateWith:(NSString *)date success:(CBYNewsToolBlock)success failure:(CBYNewsFailureBlock)failure{
    
    NSString *url;
    if (!tool) {
         tool = [[CBYNewsTool alloc] init];
    }

    if ([date isEqualToString:@"latest"]) {
        url = @"http://news-at.zhihu.com/api/4/news/latest";
    }else{
        url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/before/%@", date];
    }
    
    [CBYHttpTool get:url parameters:nil success:^(id json) {
        CBYNewsData *data = [CBYNewsData mj_objectWithKeyValues:json];
        tool.data = data;
        success(json);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)setData:(CBYNewsData *)data{
    _data = data;
    [tool.indexes addObjectsFromArray:[data.stories valueForKeyPath:@"index"]];
    [tool.dictionary setValue:tool.indexes forKey:@"news"];
}

+ (void)setData:(CBYNewsData *)data{
    tool.data = data;
}

+ (void)getThemeDetailWith:(NSNumber *)index success:(CBYNewsToolBlock)success failure:(CBYNewsFailureBlock)failure{
    if (!tool) {
        tool = [[CBYNewsTool alloc] init];
    }
    
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%@", index];
    
    [CBYHttpTool get:url parameters:nil success:^(id json) {
        CBYThemeDetail *detail = [CBYThemeDetail mj_objectWithKeyValues:json];
        tool.detail = detail;
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)setDetail:(CBYThemeDetail *)detail{
    _detail = detail;
    [tool.indexes addObjectsFromArray:[detail.stories valueForKeyPath:@"index"]];
    [tool.dictionary setValue:tool.indexes forKey:detail.name];
}

+ (void)setDetail:(CBYThemeDetail *)detail{
    tool.detail = detail;
}

+ (BOOL)isTheFirstNewsWithIndex:(NSNumber *)index{
    if ([index isEqual:tool.indexes[0]]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTheLastNewsWithIndex:(NSNumber *)index{
    if ([index isEqual:[tool.indexes lastObject]]) {
        return YES;
    }
    return NO;
}

+ (NSNumber *)getNextNewsIndexWithIndex:(NSNumber *)index{
    NSInteger next = [tool.indexes indexOfObject:index];
    return [tool.indexes objectAtIndex:++next];
}

+ (NSNumber *)getLastNewsIndexWithIndex:(NSNumber *)index{
    NSInteger last = [tool.indexes indexOfObject:index];
    return [tool.indexes objectAtIndex:--last];
}

//根据key取出对应的id;
+ (void)changeTheme:(NSNotification *)noti{
    CBYTheme *theme = noti.userInfo[@"theme"];
    if ([theme.name isEqualToString:@"首页"]) {
        tool.indexes = [tool.dictionary valueForKey:@"news"];
    }else{
        tool.indexes = [tool.dictionary valueForKey:[NSString stringWithFormat:@"%@", theme.name]];
    }
}

- (void)dealloc{
    [CBYNOTICENTER removeObserver:self];
}

@end
