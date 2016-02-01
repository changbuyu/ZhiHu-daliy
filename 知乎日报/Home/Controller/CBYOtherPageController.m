//
//  CBYOtherPageController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/12.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYOtherPageController.h"
#import "CBYNavigationBar.h"
#import "CBYTopImageView.h"
#import "CBYTheme.h"
#import "CBYNewsTool.h"
#import "CBYThemeDetail.h"
#import "CBYNewsCell.h"
#import "CBYNews.h"
#import "CBYEditorsCell.h"
#import "CBYContainController.h"
#import "MBProgressHUD+MJ.h"
#import "CBYSqliteTool.h"
#import "MJExtension.h"
@interface CBYOtherPageController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) CBYNavigationBar *navigationBar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) CGFloat oldOffset;
@property (nonatomic, weak) CBYTopImageView *imageView;
@property (nonatomic, strong) CBYThemeDetail *themeDetail;
@end

@implementation CBYOtherPageController

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

#pragma mark ---- 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航条
    [self setupNavigationBar];
    //添加tableView;
    [self setupTableView];
    //添加头部imageView
    [self setupImageView];
    
    [self.navigationBar addObserveToScrollView:self.tableView target:self action:nil];
}

- (void)setTheme:(CBYTheme *)theme{
    _theme = theme;
    self.navigationBar.theme = theme;
    /**
     *  拿到主题后,发送网络请求数据
     */
    [self updateThemes];
}

- (void)setupNavigationBar{
    CBYNavigationBar *navigationBar = [[CBYNavigationBar alloc] init];
    [navigationBar.contentView removeFromSuperview];
    [navigationBar.statusView removeFromSuperview];
    navigationBar.origin = CGPointZero;
    navigationBar.size = CGSizeMake(CBYSCREENW, 64);
    [self.view addSubview:navigationBar];
    self.navigationBar = navigationBar;
}

- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:tableView belowSubview:self.navigationBar];
    tableView.contentInset = UIEdgeInsetsMake(CBYNavigationBarHeight, 0, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    self.oldOffset = tableView.contentOffset.y;
}

- (void)setupImageView{
    CBYTopImageView *topView = [[CBYTopImageView alloc] init];
    [topView addObserveTo:self.tableView];
    [self.view insertSubview:topView belowSubview:self.navigationBar];
    topView.frame = self.navigationBar.bounds;
    self.imageView = topView;
}

/**
 *  发送网络请求
 */
- (void)updateThemes{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = @"themes";
    dict[@"idstr"] = [NSString stringWithFormat:@"%@", self.theme.color];
    NSArray *array = [CBYSqliteTool readDataWith:dict];
    
    void(^loadData)(CBYThemeDetail *) = ^(CBYThemeDetail *detail){
        [CBYNewsTool setDetail:detail];
        self.themeDetail = detail;
        self.imageView.thumbnail = self.themeDetail.background;
        [self.tableView reloadData];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:NO];
    };
    
    if (array.count) {
        CBYThemeDetail *detail = [CBYThemeDetail mj_objectWithKeyValues:array[0]];
        loadData(detail);
    }
    
    [CBYNewsTool getThemeDetailWith:self.theme.index success:^(id obj) {
        [CBYSqliteTool saveDataWith:obj extraInfo:nil withName:@"themes"];
        CBYThemeDetail *detail = [CBYThemeDetail mj_objectWithKeyValues:obj];
        loadData(detail);
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力"];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themeDetail.stories.count;
}
/**
 *  根据不同id返回不用样式的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            CBYEditorsCell *cell = [CBYEditorsCell editorsCell:tableView];
            cell.editors = self.themeDetail.editors;
            return cell;
        }
            break;
            
        default:{
            CBYNewsCell *cell = [CBYNewsCell newsCell:tableView];
            cell.news = self.themeDetail.stories[indexPath.row - 1];
            return cell;
        }
            break;
    }
    return nil;
}
#pragma mark ---- 代理方法
/**
 *  返回不同行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 30;
            break;
            
        default:
            return 80;
            break;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.oldOffset - scrollView.contentOffset.y > CBYNavigationBarHeight) {
        CGPoint offset = CGPointMake(scrollView.contentOffset.x, self.oldOffset - CBYNavigationBarHeight);
        scrollView.contentOffset = offset;
    }
}
//结束拖拽后刷新表格
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.navigationBar.block = ^{
        self.navigationBar.activityView.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.navigationBar.activityView.hidden = YES;
            self.navigationBar.refreshing = NO;
        });
        self.navigationBar.block = nil;
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            NSLog(@"%s", __func__);
            break;
            
        default:{
            CBYNews *news = self.themeDetail.stories[indexPath.row - 1];
            CBYContainController *conVc = [[CBYContainController alloc] init];
            conVc.index = news.index;
            [self.navigationController pushViewController:conVc animated:YES];
        }
            break;
    }
    
}
@end
