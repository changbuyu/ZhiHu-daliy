//
//  CBYHomePageController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/12.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYHomePageController.h"
#import "CBYNavigationBar.h"
#import "CBYTopView.h"
#import "CBYNewsData.h"
#import "CBYNewsCell.h"
#import "MJRefresh.h"
#import "CBYHeadView.h"
#import "CBYNews.h"
#import "MJExtension.h"
#import "CBYContainController.h"
#import "CBYNewsTool.h"
#import "CBYSqliteTool.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Extension.h"
static const CGFloat kSectionHeight = 30;
static const CGFloat kRowHeight = 80;

@interface CBYHomePageController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) CBYNavigationBar *navigationBar;
@property (nonatomic, weak) CBYTopView *topView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) CGFloat oldOffset;
@property (nonatomic, copy) NSString *lastDate;
@property (nonatomic, copy) NSMutableArray *dates;
@property (nonatomic, strong) NSMutableArray *sections;
/** 记录第一次调用加载更多时的日期,即启动程序时第一次加载数据日期的昨天 */
@property (nonatomic, copy) NSString *loadMoreDate;
/** 记录已经加载的日期 */
@property (nonatomic, copy) NSString *downDate;
/** 用于标记block调用次数,确定数据插入数组的位置 */
@property (nonatomic, assign) NSInteger inserIndex;
/** 标记是否加载之前的数据 */
@property (nonatomic, assign, getter = isOld) BOOL old;
@end

@implementation CBYHomePageController

- (NSMutableArray *)dates{
    if (!_dates) {
        _dates = [NSMutableArray array];
    }
    return _dates;
}
/**
 *  存放stories的数组
 */
- (NSMutableArray *)sections{
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}


#pragma mark ---- 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  刚进入程序时,下载日期
     */
    NSString *today = [NSString getYearMonthAndDayWithDate:[NSDate date]];
    self.downDate = [NSString yesterDayDateWith:today];
    
    //设置导航条
    [self setupNavigationBar];
    //添加tableView;
    [self setupTableView];
    
    [self.navigationBar addObserveToScrollView:self.tableView target:self action:nil];
    self.tableView.rowHeight = kRowHeight;
    //加载程序时加载两天的数据
    [self upDateNews:nil];
//    [self loadMoreStories];
    /**
     *  添加上拉刷新
     */
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStories)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.transform = CGAffineTransformIdentity;
    [self.topView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.topView.timer invalidate];
    self.topView.timer = nil;
}

- (void)setupNavigationBar{
    CBYNavigationBar *navigationBar = [[CBYNavigationBar alloc] init];
    navigationBar.origin = CGPointZero;
    navigationBar.size = CGSizeMake(CBYSCREENW, CBYNavigationBarHeight);
    [self.view addSubview:navigationBar];
    self.navigationBar = navigationBar;
}

- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:tableView belowSubview:self.navigationBar];
    tableView.contentInset = UIEdgeInsetsMake(CBYTopViewHeight - CBYNavigationBarHeight, 0, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    CBYTopView *topView = [[CBYTopView alloc] init];
    [tableView insertSubview:topView atIndex:0];
    
    topView.frame = tableView.bounds;
    topView.y =  - CBYTopViewHeight;
    topView.height = CBYTopViewHeight;
    self.topView = topView;
    self.tableView = tableView;
    self.oldOffset = tableView.contentOffset.y;
    
    __weak typeof(self) weakSelf = self;
    topView.block = ^(CBYContainController *conVc){
        [weakSelf.navigationController pushViewController:conVc animated:YES];
    };
}

//获取网络数据
- (void)upDateNews:(void(^)())block{
    /**
     *  新数据直接从网络获取,当网络不通时,加载缓存数据
     */
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = @"latest";
    NSArray *array = [CBYSqliteTool readDataWith:dict];
    
    void(^loadData)(CBYNewsData *) = ^(CBYNewsData *data){
        [CBYNewsTool setData:data];
        self.topView.top_stroies = data.top_stories;
        self.lastDate = data.date;
        self.navigationBar.newsDate = data.date;
        if (self.sections.count) {
            if (self.sections.count == data.stories.count) return;
            [self.sections replaceObjectAtIndex:0 withObject:data.stories];
            [self.dates replaceObjectAtIndex:0 withObject:data.date];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:0];
        }else{
            [self.sections addObject:data.stories];
            [self.dates addObject:data.date];
            [self.tableView reloadData];
        }
        
    };

    [CBYNewsTool getNewsDateWith:@"latest" success:^(id obj) {
        [CBYSqliteTool saveDataWith:obj extraInfo:nil withName:@"latest"];
        CBYNewsData *newData = [CBYNewsData mj_objectWithKeyValues:obj];
        loadData(newData);
        //网络请求结束后结束刷新状态
        if (block) {
            block();
        }
        if (self.loadMoreDate) {
            self.old = NO;
            while (![self.downDate isEqualToString:self.loadMoreDate]) {
                self.old = YES;
                NSInteger number = self.downDate.integerValue;
                self.downDate = [NSString stringWithFormat:@"%ld", -- number];
                self.inserIndex ++;
                [self loadMoreStories];
            };
        }
        
    } failure:^(NSError *error) {
        if (array.count) {
            CBYNewsData *data = [CBYNewsData mj_objectWithKeyValues:array[0]];
            loadData(data);
            self.loadMoreDate = [NSString yesterDayDateWith:data.date];
        }
        
        [MBProgressHUD showError:@"网络不给力"];
        if (block) {
            block();
        }
    }];
}

- (void)loadMoreStories{
    /**
     *  旧数据优先从沙盒中读取
     */
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = @"before";
    dict[@"idstr"] = [NSString stringWithFormat:@"%ld",([self.lastDate integerValue] - 1)];
    NSArray *array = [CBYSqliteTool readDataWith:dict];
    
    void(^loadData)(CBYNewsData *) = ^(CBYNewsData *data){
//        CBYLog(@"%ld", inserIndex);
        [CBYNewsTool setData:data];
        self.lastDate = data.date;
        if (self.isOld) {
            [self.dates insertObject:data.date atIndex:_inserIndex];
            [self.sections insertObject:data.stories atIndex:_inserIndex];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:_inserIndex] withRowAnimation:0];
        }else{
            [self.dates addObject:data.date];
            [self.sections addObject:data.stories];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.sections.count - 1] withRowAnimation:0];
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        self.navigationBar.totleOffset = self.tableView.contentSize.height;
//        CBYLog(@"%@", self.);
    };

    if (array.count) {
        CBYNewsData *data = [CBYNewsData mj_objectWithKeyValues:array[0]];
        loadData(data);
    }else{
        [CBYNewsTool getNewsDateWith:self.lastDate success:^(id obj) {
            [CBYSqliteTool saveDataWith:obj extraInfo:nil withName:@"before"];
            CBYNewsData *newData = [CBYNewsData mj_objectWithKeyValues:obj];
            loadData(newData);
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络不给力"];
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *stroies = self.sections[section];
    return stroies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableArray *tmpArray = [NSMutableArray array];
    
    CBYNewsCell *cell = [CBYNewsCell newsCell:tableView];
    NSArray *stroies = self.sections[indexPath.section];
    cell.news = stroies[indexPath.row];
    return cell;
}

#pragma mark ---- 代理方法
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
        [self.navigationBar.activityView startAnimating];
        [self upDateNews:^{
            [self.navigationBar.activityView stopAnimating];
            self.navigationBar.activityView.hidden = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.navigationBar.refreshing = NO;
            });
        }];
        self.navigationBar.block = nil;
    };
}
//点击tableViewcell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray *stories = self.sections[indexPath.section];
    CBYNews *news = stories[indexPath.row];
    CBYContainController *conVc = [[CBYContainController alloc] init];
    conVc.index = news.index;
    NSLog(@"%@", news.index);
    [self.navigationController pushViewController:conVc animated:YES];
    
}
//返回header的高度,section为0时,没有header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ? kSectionHeight : CGFLOAT_MIN;
}
//返回footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CBYHeadView *header = [CBYHeadView headerView:tableView];
    header.frame = CGRectMake(0, 0, self.view.width, kSectionHeight);;
    header.date = self.dates[section];
    [header addObserverToView:self.navigationBar];
    self.navigationBar.date = header.date;
    self.navigationBar.index = section;
    return section ? header : nil;
}


@end
