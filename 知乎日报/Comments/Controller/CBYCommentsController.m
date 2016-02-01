//
//  CBYCommentsController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/30.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYCommentsController.h"
#import "CBYNavBar.h"
#import "CBYCommentTool.h"
#import "CBYBottomBar.h"
#import "CBYLoginController.h"
#import "CBYCommentCell.h"
#import "CBYDetailTool.h"
#import "CBYExtra.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CBYHeadButton.h"
#import "CBYNocommentView.h"

static const CGFloat kBottombarHeight = 36;
static const CGFloat kHeadViewHeight = 30;

@interface CBYCommentsController ()<CBYBottomBarDelegate, UITableViewDataSource, UITableViewDelegate, CBYCommentCellDelegate>
/** 导航条 */
@property (nonatomic, weak) CBYNavBar *bar;
/** 长评论 */
@property (nonatomic, strong) NSArray *longComments;
/** 短评论 */
@property (nonatomic, strong) NSArray *shortComments;
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** section数 */
@property (nonatomic, assign) NSInteger sectionCount;
/** head按钮 */
@property (nonatomic, weak) CBYHeadButton *headButton;
/** 短评的sectionde 高度,用于判断是否滚到底部 */
@property (nonatomic, assign) CGFloat shortSectionHeight;
/** 监控短评的展开与收起 */
@property (nonatomic, assign, getter = isOpen) BOOL open;
/** 展开短评时,tablView需要上滚的距离 */
@property (nonatomic, assign) CGFloat offset;
/** 展开短评之前的offset */
@property (nonatomic, assign) CGPoint oldOffset;
@end

@implementation CBYCommentsController

- (NSArray *)longComments{
    if (!_longComments) {
        _longComments = [NSArray array];
    }
    return _longComments;
}

- (NSArray *)shortComments{
    if (!_shortComments) {
        _shortComments = [NSArray array];
    }
    return _shortComments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置tableView
    [self setupTableView];
    //设置导航条
    [self setupNavbar];
    //设置bottomBar
    [self setupBottombar];
    
}
#pragma mark --- 初始化方法
- (void)setupTableView{
    /**
     需要header跟随一起滚动,设置样式为grouped
     */
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.contentInset = UIEdgeInsetsMake(CBYNavigationBarHeight, 0, kBottombarHeight, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CBYCommentCell class] forCellReuseIdentifier:CBYCommentCellReusedID];

    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setupNavbar {
    CGRect frame = self.view.bounds;
    frame.size.height = CBYNavigationBarHeight;
    CBYNavBar *bar = [[CBYNavBar alloc] initWithFrame:frame];
    bar.backgroundColor = CBYCOLOR(23, 124, 200);
    bar.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bar];
    self.bar = bar;
}

- (void)setupBottombar{
    CBYBottomBar *bar = [[CBYBottomBar alloc] init];
    bar.frame = self.view.bounds;
    bar.height = kBottombarHeight;
    bar.y = CBYSCREENH - kBottombarHeight;
    [self.view addSubview:bar];
    bar.delegate = self;
}


- (void)setIndex:(NSNumber *)index{
    _index = index;
    [self updataWithIndex:index];
}

- (void)updataWithIndex:(NSNumber *)index{
    
    [CBYCommentTool longCommentsWithIndex:[NSString stringWithFormat:@"%@", index] success:^(NSArray *array) {
        self.longComments = array;
        [CBYCommentTool shortCommentsWithIndex:[NSString stringWithFormat:@"%@", index] success:^(NSArray *array) {
            self.shortComments = array;
            [self.tableView reloadData];
        }];
    }];
    [CBYDetailTool getExtraWithIndex:index success:^(id obj, NSString *css) {
        CBYExtra *extra = (CBYExtra *)obj;
        self.bar.titleLabel.text = [NSString stringWithFormat:@"%@条评论", extra.comments];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.shortComments.count) {
        _sectionCount = 2;
    }else{
        _sectionCount = 1;
    }
    return _sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows;
    if (_sectionCount == 1) {
        if (_longComments.count) {
            rows = self.longComments.count;
        }else{
            rows = self.isOpen ? self.shortComments.count : 0;
        }
    }else if (_sectionCount == 2){
        if (section == 0) {
            rows = self.longComments.count;
        }else {
            rows = self.isOpen ? self.shortComments.count : 0;
        }
    }else{
        rows = 0;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBYCommentCell *cell = [CBYCommentCell commentCell:tableView];
    cell.deleagate = self;
    [self configCell:cell indexPath:indexPath];
    
    if (_sectionCount == 2) {
        CGRect rect = [self.tableView rectForSection:0];
        self.offset = rect.size.height - CBYNavigationBarHeight;
        CGRect shortRect = [self.tableView rectForSection:1];
        self.shortSectionHeight = shortRect.size.height;
    }
    return cell;
}

- (void)configCell:(CBYCommentCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (_sectionCount == 1) {
        if (_longComments.count) {
            cell.comment = self.longComments[indexPath.row];
        }else{
            cell.comment = self.shortComments[indexPath.row];
        }
    }else{
        if (indexPath.section == 0) {
            cell.comment = self.longComments[indexPath.row];
        }else if (indexPath.section == 1){
            cell.comment = self.shortComments[indexPath.row];
        }
    }
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:CBYCommentCellReusedID cacheByIndexPath:indexPath configuration:^(CBYCommentCell *cell) {
        [self configCell:cell indexPath:indexPath];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    CBYNocommentView *noneView = [[CBYNocommentView alloc] init];
    
    CBYHeadButton *button = [[CBYHeadButton  alloc] init];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (_sectionCount == 1) {
        if (_longComments.count) {
            button.textLabel.text = [NSString stringWithFormat:@"%ld条长评", _longComments.count];
            button.enabled = NO;
            return button;
        }else{
            noneView.label.hidden = NO;
            return noneView;
        }
    }else{
        if (!_longComments.count) {
            if (section == 0) {
                noneView.label.hidden = YES;
                return noneView;
            }else if (section == 1){
                return [self setupButton:button];
            }
        }else{
            if (section == 0) {
                button.textLabel.text = [NSString stringWithFormat:@"%ld条长评", _longComments.count];
                button.enabled = NO;
                return button;
            }else if (section == 1){
                return [self setupButton:button];
            }
        }
        
    }
    return nil;;
}

- (CBYHeadButton *)setupButton:(CBYHeadButton *)button{
    button.textLabel.text = [NSString stringWithFormat:@"%ld条短评", _shortComments.count];
    button.iconView.image = [UIImage imageNamed:@"Dark_Comment_Icon_Fold_Highlight"];
    self.headButton = button;
    return button;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (_sectionCount == 2 && _shortComments.count && section == 0 && !_longComments.count) {
        height = CBYSCREENH - CBYNavigationBarHeight - kBottombarHeight - kHeadViewHeight;
    }else if (_sectionCount == 1 && !_longComments.count){
        height = CBYSCREENH - CBYNavigationBarHeight - kBottombarHeight;
    }else{
        height = kHeadViewHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark ---- 代理方法

- (void)bottomBar:(CBYBottomBar *)bottombar name:(NSString *)name{
    if ([name isEqualToString:CBYBottomBarBackButton]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        CBYLoginController *login = [[CBYLoginController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }
}

- (void)commentCell:(CBYCommentCell *)commentCell open:(BOOL)open{
//    NSIndexPath *path = [self.tableView indexPathForCell:commentCell];
//    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:NO];
}

#pragma mark ---- 响应事件
- (void)buttonClick{
    if (!self.isOpen) {
        self.oldOffset = self.tableView.contentOffset;
    }
    
    self.open = ! self.isOpen;
    /**
     *  如果有短评,肯定是section1
     */
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
    [self.tableView reloadSections:set withRowAnimation:NO];
    
    if (self.isOpen) {
        if(self.shortSectionHeight < CBYSCREENH - CBYNavigationBarHeight - kBottombarHeight - kHeadViewHeight){
            NSIndexPath *path = [NSIndexPath indexPathForRow:(_shortComments.count - 1) inSection:1];
            [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }else{
            [self.tableView setContentOffset:CGPointMake(0, self.offset) animated:YES];
        }
    }else{
        [self.tableView setContentOffset:self.oldOffset animated:YES];
    }
    
    if (!self.isOpen) {
        self.headButton.iconView.transform = CGAffineTransformIdentity;
    }else{
        self.headButton.iconView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

@end
