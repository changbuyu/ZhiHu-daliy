//
//  CBYTopView.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/13.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYTopView.h"
#import "CBYTopViewCell.h"
#import "Masonry.h"
#import "NSTimer+CBYTimer.h"
#import "CBYContainController.h"
#import "CBYNews.h"
static const NSInteger kNumbersOfPage = 5;

@interface CBYTopView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic)  UICollectionView *collectionView;
@property (weak, nonatomic)  UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;


@end

@implementation CBYTopView

- (instancetype)init{
    if (self = [super init]) {
        [self setupCollectionView];
        [self setupPageControl];
        [self addTimer];
    }
    return self;
}
//设置collectionView,用于图片轮播
- (void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout = layout;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [collectionView registerNib:[UINib nibWithNibName:@"CBYTopViewCell" bundle:nil] forCellWithReuseIdentifier:CBYReusedID];
    [self addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    self.collectionView = collectionView;
}
//设置pagecontrol
- (void)setupPageControl{
    UIPageControl *pagecontrol = [[UIPageControl alloc] init];
    pagecontrol.userInteractionEnabled = NO;
    [self addSubview:pagecontrol];
    pagecontrol.numberOfPages = kNumbersOfPage;
    self.pageControl = pagecontrol;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.layout.itemSize = self.bounds.size;
    self.collectionView.frame = self.bounds;
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    //设置collectionView的偏移量
    self.collectionView.contentOffset = CGPointMake(self.width * 2, 0);
}

- (void)addTimer{
    //添加定时器

    if (!self.timer) {
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}
//定时切换图片
- (void)changeImage{
    CGFloat offset = self.collectionView.contentOffset.x;
    offset += self.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

//设置视图内容
- (void)setTop_stroies:(NSArray *)top_stroies{
    _top_stroies = top_stroies;
    [self.collectionView reloadData];
}

#pragma mark --- dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return kNumbersOfPage + 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CBYTopViewCell *cell = [CBYTopViewCell topViewCell:collectionView forIndexPath:indexPath];
    NSInteger count = self.top_stroies.count;
    switch (indexPath.row) {
        case 0:
            cell.news = self.top_stroies[count - 2];
            break;
        case 1:
            cell.news = self.top_stroies[count - 1];
            break;
        case kNumbersOfPage + 2:
            cell.news = self.top_stroies[0];
            break;
        case kNumbersOfPage + 3:
            cell.news = self.top_stroies[1];
            break;
            
        default:
            cell.news = self.top_stroies[indexPath.row - 2];
            break;
    }
    
    return cell;
}
#pragma mark ---- 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CBYTopViewCell * cell = (CBYTopViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CBYContainController *conVc = [[CBYContainController alloc] init];
    conVc.index = cell.news.index;
    self.block(conVc);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer pauseTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat count = offset / self.width;
    self.pageControl.currentPage = count + 0.5 - 2;
    
    if (offset <= self.width) {
        offset = self.width * (kNumbersOfPage + 1);
        self.pageControl.currentPage = kNumbersOfPage;
    }else if (offset >= self.width * (kNumbersOfPage + 2)){
        offset = self.width * 2;
        self.pageControl.currentPage = 1;
    }
    scrollView.contentOffset = CGPointMake(offset, 0);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timer resumeTimerAfterTimeInterval:3.0];
}

- (void)dealloc{
    [self.timer invalidate];
}
@end
