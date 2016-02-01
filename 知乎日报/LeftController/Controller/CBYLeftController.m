//
//  CBYLeftController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/11.
//  Copyright © 2016年 CBY. All rights reserved.
//
#define CBYFILEPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"themes.data"]
#import "CBYLeftController.h"
#import "CBYLeftViewCell.h"
#import "CBYHttpTool.h"
#import "CBYTheme.h"
#import "MJExtension.h"
#import "CBYLoginController.h"
#import "CBYSettingController.h"
@interface CBYLeftController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *themes;
@end

@implementation CBYLeftController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfFile:CBYFILEPATH];
    if (data) {
        NSArray *savedThemes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.themes = savedThemes;
    }else{
        [self creatdata];
    }
}

- (void)creatdata{
    NSMutableArray *tmpArray = [NSMutableArray array];
    CBYTheme *theme = [[CBYTheme alloc] init];
    theme.name = @"首页";
    [tmpArray addObject:theme];
    
    [CBYHttpTool get:@"http://news-at.zhihu.com/api/4/themes" parameters:nil success:^(id json) {
        NSArray *themes = [CBYTheme mj_objectArrayWithKeyValuesArray:json[@"others"]];
        [tmpArray addObjectsFromArray:themes];
        [NSKeyedArchiver archiveRootObject:tmpArray toFile:CBYFILEPATH];
        [self selectDefaultRow];
        self.themes = tmpArray;
        self.block(self.themes[0]);
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        CBYLog(@"%@", error);;
    }];
}

- (void)selectDefaultRow{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    CBYLeftViewCell *defaultCell = [self.tableView cellForRowAtIndexPath:path];
    defaultCell.selected = YES;
}

#pragma mark --- 点击事件
- (IBAction)loginClick:(UIButton *)sender {
    CBYLoginController *login = [[CBYLoginController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}

- (IBAction)collectionClick:(UIButton *)sender {
    CBYLoginController *login = [[CBYLoginController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}

- (IBAction)messageClick:(UIButton *)sender {
}

- (IBAction)settingClick:(UIButton *)sender {
    CBYSettingController *setting = [[CBYSettingController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (IBAction)downloadClick:(UIButton *)sender {
}

- (IBAction)modelClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBYLeftViewCell *cell = [CBYLeftViewCell leftViewCell:tableView];
    cell.theme = self.themes[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *  第一次点别的cell就将第一个cell的selected设置为no;若第一次点的时第一个cell 直接return;
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (indexPath.row == 0) return;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.selected = NO;
    });
    CBYTheme *theme = self.themes[indexPath.row];
    [CBYNOTICENTER postNotificationName:CBYChangeThemeNotification object:nil userInfo:@{@"theme" : theme}];
    self.block(theme);
}


@end
