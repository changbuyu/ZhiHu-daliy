//
//  CBYScrollView.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/26.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYScrollView.h"
#import "CBYShareModel.h"
#import "UIView+Extension.h"
#import "CBYShareButton.h"
const NSInteger kPerPageButtonNumbers = 8;

@interface CBYScrollView ()
@property (nonatomic, strong) NSArray *shareModels;
@property (nonatomic, weak) UIView *firstView;
@property (nonatomic, weak) UIView *secondView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation CBYScrollView

- (NSArray *)shareModels{
    if (!_shareModels) {
        _shareModels = [CBYShareModel shareModels];
    }
    return _shareModels;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = CBYCOLOR(230, 230, 230);
        self.contentSize = CGSizeMake(self.size.width * 2, 0);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        [self addShareSubView];
    }
    return self;
}

- (void)addShareSubView{
    UIView *first = [[UIView alloc] initWithFrame:self.bounds];
    for (int i = 0; i < kPerPageButtonNumbers; i++) {
        CBYShareButton *button = [[CBYShareButton alloc] init];
        button.model = self.shareModels[i];
        [first addSubview:button];
    }
    first.backgroundColor = [UIColor clearColor];
    [self addSubview:first];
    self.firstView = first;
    
    UIView *second = [[UIView alloc] initWithFrame:self.bounds];
    second.x = self.width;
    for (int i = kPerPageButtonNumbers; i < self.shareModels.count ; i++) {
        CBYShareButton *button = [[CBYShareButton alloc] init];
        button.model = self.shareModels[i];
        [second addSubview:button];
    }
    second.backgroundColor = [UIColor clearColor];
    [self addSubview:second];
    self.secondView = second;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat viewW = self.width * 0.25;
    CGFloat viewH = self.height * 0.5;
    __block CGFloat viewX = 0;
    __block CGFloat viewY = 0;
    
    [self.firstView.subviews enumerateObjectsUsingBlock:^(CBYShareButton *obj, NSUInteger idx, BOOL *stop) {
        NSInteger row = idx / 4;
        NSInteger colnum = idx % 4;
        viewX = viewW * colnum;
        viewY = viewH * row;
        obj.frame = CGRectMake(viewX, viewY, viewW, viewH);
        
    }];
   
    [self.secondView.subviews enumerateObjectsUsingBlock:^(CBYShareButton *obj, NSUInteger idx, BOOL *stop) {
        NSInteger row = idx / 4;
        NSInteger colnum = idx % 4;
        viewX = viewW * colnum;
        viewY = viewH * row;
        obj.frame = CGRectMake(viewX, viewY, viewW, viewH);
        
    }];
}

/**
 *  还是使用button
 */

- (void)test{
//    - (void)addShareSubView{
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing = 0.0;
//        layout.minimumInteritemSpacing = 0.0;
//        layout.itemSize = CGSizeMake(self.width * 0.25, self.height * 0.5);
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        //    self.layout = layout;
//        
//        UICollectionView *firstView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
//        firstView.showsHorizontalScrollIndicator = NO;
//        firstView.backgroundColor = CBYCOLOR(230, 230, 230);
//        [firstView registerClass:[CBYShareViewCell class] forCellWithReuseIdentifier:reusedIdentifier];
//        firstView.delegate = self;
//        firstView.dataSource = self;
//        firstView.frame = self.bounds;
//        [self addSubview:firstView];
//        self.firstView = firstView;
//    }
//    
//#pragma mark ---- 数据源方法
//    - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//        return self.shareModels.count;
//    }
//    
//    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//        CBYShareViewCell *cell = [CBYShareViewCell shareViewCell:collectionView forIndexPath:indexPath];
//        CBYShareModel *model = self.shareModels[indexPath.row];
//        cell.shareModel = model;
//        return cell;
//    }
 
}

@end
