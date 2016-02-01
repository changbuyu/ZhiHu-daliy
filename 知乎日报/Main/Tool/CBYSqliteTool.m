//
//  CBYSqliteTool.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYSqliteTool.h"
#import "FMDB.h"
static FMDatabase *_db;

@implementation CBYSqliteTool
+ (void)initialize{
    /**
     *  创建存储路径
     */
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.db"];
    
    /**
     *  创建并打开数据库
     */
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    /**
     *  创表
     *  表1,存放最新的stories
     *  表2,存放之前所有的stories
     *  表3,存放story详细内容与css
     *  表4,存放每条story额外的信息
     *  表5,存放主题新闻
     */

    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_latest (id integer PRIMARY KEY, data bolb, idstr text)"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_before (id integer PRIMARY KEY, data bolb, idstr text)"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_stories (id integer PRIMARY KEY, data bolb, css text, idstr text)"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_extra (id integer PRIMARY KEY, data bolb, idstr text)"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_themes (id integer PRIMARY KEY, data bolb, idstr text)"];
    
   
    
}

/**
 *  读取数据
 *
 *  @param dict 传递过来的参数,包括表名与id,根据id取出对应的数据
 */
+ (NSArray *)readDataWith:(NSDictionary *)dict{
    NSString *sql;
    NSString *name = dict[@"name"];
    NSString *idstr = dict[@"idstr"];
    if ([name isEqualToString:@"latest"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_latest"];
    }else if ([name isEqualToString:@"before"]){//一次取一天的新闻
        sql = [NSString stringWithFormat:@"SELECT * FROM t_before WHERE idstr = %@", idstr];
    }else if ([name isEqualToString:@"stories"]){
        sql = [NSString stringWithFormat:@"SELECT * FROM t_stories WHERE idstr = %@", idstr];
    }else if ([name isEqualToString:@"themes"]){
        sql = [NSString stringWithFormat:@"SELECT * FROM t_themes WHERE idstr = %@", idstr];
    }else if ([name isEqualToString:@"extra"]){
        sql = [NSString stringWithFormat:@"SELECT * FROM t_extra WHERE idstr = %@", idstr];
    }
    NSMutableArray *tmpArray = [NSMutableArray array];
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSData *data = [set dataForColumn:@"data"];
        NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [tmpArray addObject:dictionary];
        
        if ([name isEqualToString:@"stories"]) {
            NSString *css = [set stringForColumn:@"css"];
            [tmpArray addObject:css];
        }
    }
    return tmpArray;
}

+ (void)saveDataWith:(NSDictionary *)dict extraInfo:(id)info withName:(NSString *)name{
    /**
     *  给一个静态变量,标记extra
     */
    static NSString *extraId;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    if ([name isEqualToString:@"latest"]) {
        [_db executeUpdate:@"INSERT INTO t_latest (data, idstr) VALUES (?, ?)", data, dict[@"date"]];
    }else if ([name isEqualToString:@"before"]){
        [_db executeUpdate:@"INSERT INTO t_before (data, idstr) VALUES (?, ?)", data, dict[@"date"]];
    }else if ([name isEqualToString:@"stories"]){
        [_db executeUpdate:@"INSERT INTO t_stories (data, css, idstr) VALUES (?, ?, ?)", data, info, dict[@"id"]];
        extraId = dict[@"id"];
    }else if ([name isEqualToString:@"themes"]){
        [_db executeUpdate:@"INSERT INTO t_themes (data, idstr) VALUES (?, ?)", data, dict[@"color"]];
    }else if ([name isEqualToString:@"extra"]){
        [_db executeUpdate:@"INSERT INTO t_extra (data, idstr) VALUES (?, ?)", data, extraId];
    }

}
@end

