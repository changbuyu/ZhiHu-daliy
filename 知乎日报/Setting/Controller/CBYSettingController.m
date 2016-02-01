//
//  CBYSettingController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/28.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYSettingController.h"
#import "CBYNavBar.h"
#import "CBYItem.h"
#import "CBYSwitchItem.h"
#import "CBYArrowItem.h"
#import "CBYItemGroup.h"
#import "CBYLoginController.h"
#import "CBYSettingCell.h"
#import "MBProgressHUD+MJ.h"
@interface CBYSettingController ()<CBYNavBarDelegate, UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, weak) CBYNavBar *bar;
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation CBYSettingController

- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavBar];
    [self creatGroups];
}

- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

/**
 *  设置数据
 */
- (void)creatGroups{
    CBYItemGroup *group0 = [[CBYItemGroup alloc] init];
    CBYItem *mine = [[CBYArrowItem alloc] initIcon:@"Comment_Avatar" destination:[CBYLoginController class] title:@"我的资料"];
    group0.items = @[mine];
    
    CBYItemGroup *group1 = [[CBYItemGroup alloc] init];
    CBYItem *download = [[CBYSwitchItem alloc] initTitle:@"自动离线下载"];
    group1.items = @[download];
    group1.footer = @"仅在Wi-Fi下可用,自动下载最新内容";
    
    CBYItemGroup *group2 = [[CBYItemGroup alloc] init];
    CBYItem *image = [[CBYSwitchItem alloc] initTitle:@"移动网络不下载图片"];
    CBYItem *big = [[CBYSwitchItem alloc] initTitle:@"大字号"];
    group2.items = @[image, big];
    
    CBYItemGroup *group3 = [[CBYItemGroup alloc] init];
    CBYItem *message = [[CBYSwitchItem alloc] initTitle:@"消息推送"];
    CBYItem *weibo = [[CBYSwitchItem alloc] initTitle:@"点评分享到微博"];
    group3.items= @[message, weibo];
    
    CBYItemGroup *group4 = [[CBYItemGroup alloc] init];
    CBYItem *good = [[CBYArrowItem alloc] initTitle:@"去好评"];
    CBYItem *bad = [[CBYArrowItem alloc] initTitle:@"去吐槽"];
    group4.items = @[good, bad];
    
    CBYItemGroup *group5 = [[CBYItemGroup alloc] init];
    CBYItem *cache = [[CBYItem alloc] initTitle:@"清除缓存"];
    cache.option = ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        [manager removeItemAtPath:caches error:nil];
        [MBProgressHUD showSuccess:@"清除成功"];
    };
    group5.items = @[cache];
    
    [self.groups addObjectsFromArray:@[group0, group1, group2, group3, group4, group5]];
}
/**
 *  设置导航条
 */
- (void)setupNavBar{
    CGRect frame = self.view.bounds;
    frame.size.height = CBYNavigationBarHeight;
    CBYNavBar *bar = [[CBYNavBar alloc] initWithFrame:frame];
    bar.backgroundColor = CBYCOLOR(23, 124, 200);
    bar.titleLabel.text = @"设置";
    bar.titleLabel.textAlignment = NSTextAlignmentCenter;
    bar.delegate = self;
    [self.view addSubview:bar];
    self.bar = bar;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tmpArray = [self.groups[section] items];
    return tmpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBYSettingCell *cell = [CBYSettingCell settingCell:tableView];
    NSArray *tmpArray = [self.groups[indexPath.section] items];
    cell.item = tmpArray[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [self.groups[section] footer];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBYSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CBYItem *item = cell.item;
    if (item.option) {
        item.option();
    }else if ([item isKindOfClass:[CBYArrowItem class]]){
        CBYArrowItem *arrow = (CBYArrowItem *)item;
        if (arrow.destination) {
            UIViewController *viewContorller = [[arrow.destination alloc] init];
            //如果是登陆控制器,就给showType赋值;
            if ([viewContorller isKindOfClass:[CBYLoginController class]]) {
                CBYLoginController *login = (CBYLoginController *)viewContorller;
                login.showType = CBYLoginControllerShowTypepush;
            }
            [self.navigationController pushViewController:viewContorller animated:YES];
        }
    }
    
}

- (void)navBar:(CBYNavBar *)navbar{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
