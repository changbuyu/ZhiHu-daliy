//
//  CBYNavigationBar.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/13.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYNavigationBar.h"
#import "Masonry.h"
#import "NSString+Extension.h"

static const CGFloat kChangeLabelMargin = 34;

@interface CBYNavigationBar ()
@property (weak, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic)  UIButton *leftButton;
@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UILabel *lastDateLabel;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat oldOffset;
@property (nonatomic, assign) CGFloat delta;
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, copy) NSString *nextDay;
@property (nonatomic, assign) CGFloat marginY;

@end
@implementation CBYNavigationBar

- (NSMutableArray *)offsets{
    if (!_offsets) {
        _offsets = [NSMutableArray array];
    }
    return _offsets;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = CBYCOLOR(24, 123, 200);
        [self addSubview:contentView];
        self.contentView = contentView;
        
        UIButton *leftButton = [[UIButton alloc] init];
        [self addSubview:leftButton];
        self.leftButton = leftButton;
        leftButton.adjustsImageWhenHighlighted = NO;
        [leftButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel = titleLabel;
        
        UILabel *dateLabel = [[UILabel alloc] init];
        [self addSubview:dateLabel];
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont systemFontOfSize:14];
        dateLabel.hidden = YES;
        self.dateLabel = dateLabel;
        
        UILabel *lastDateLabel = [[UILabel alloc] init];
        [self addSubview:lastDateLabel];
        lastDateLabel.textColor = [UIColor whiteColor];
        lastDateLabel.font = [UIFont systemFontOfSize:14];
        lastDateLabel.hidden = YES;
        self.lastDateLabel = lastDateLabel;
        
        UIView *statusView = [[UIView alloc] init];
        [self addSubview:statusView];
        statusView.backgroundColor = CBYCOLOR(24, 123, 200);
        statusView.hidden = YES;
        self.statusView = statusView;
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:activityView];
        self.activityView = activityView;
        
        [self.leftButton setBackgroundImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
        self.titleLabel.text = @"今日热闻";
        
        self.contentView.alpha = 0.0;
        self.activityView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat padding = 15.0;
    
    self.contentView.frame = self.bounds;
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(19);
        make.left.equalTo(self.mas_left).with.offset(padding);
        make.bottom.equalTo(self.mas_bottom).with.offset(-padding);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).with.offset(-padding);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).with.offset(-padding);
    }];
    
    [self.lastDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_bottom);
    }];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.titleLabel.mas_left).with.offset(-10);
    }];
    
    self.statusView.frame = self.bounds;
    self.statusView.height = 20;
    
    if (self.dateLabel.hidden == NO && !self.marginY) {
        self.marginY = CGRectGetMidY(self.dateLabel.frame) - CGRectGetMidY(self.lastDateLabel.frame);
    }
}

- (void)setTheme:(CBYTheme *)theme{
    _theme = theme;
    self.titleLabel.text = theme.name;
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"News_Arrow"] forState:UIControlStateNormal];
    
}

- (void)setTotleOffset:(CGFloat)totleOffset{
    _totleOffset = totleOffset;
    [self.offsets addObject:[NSNumber numberWithFloat:totleOffset]];
}

//点击按钮打开抽屉
- (void)buttonClick{
    [CBYNOTICENTER postNotificationName:CBYNavigationgBarNotification object:nil];
}

- (void)addObserveToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action{
    self.scrollView = scrollView;
    self.oldOffset = scrollView.contentOffset.y;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    UIScrollView *scrollView = object;
    CGFloat offset = scrollView.contentOffset.y;
    CGPoint new = [change[@"new"] CGPointValue];
    CGFloat delta = new.y - self.oldOffset;
    self.delta = delta;
    
    if (delta > 0) { // tableView在往上滚动
        [self scrollUp:offset];
    }else { // tableView在往下滚动
        [self scrollDown:offset];
    }
    
    //导航条的label切换
    [self changeLabel:offset];
}

//往上滚
- (void)scrollUp:(CGFloat)offset{
    if (offset < 0) {
        self.statusView.hidden = YES;
        if (offset < 84 - CBYTopViewHeight) {
            self.contentView.alpha = 0;
        }else{
            self.contentView.alpha = (offset + CBYTopViewHeight) / (CBYTopViewHeight - 64);
        }
    }else{
        self.contentView.alpha = 1.0;
        //显示statusView
        self.statusView.hidden = NO;
    }
    [self setNeedsDisplay];
}

//往下滚
- (void)scrollDown:(CGFloat)offset{
    self.contentView.alpha = 0.0;
    if (self.block && self.angle >= M_PI * 2) {
        self.refreshing = YES;
        self.block();
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if (self.delta >= -1 || self.isRefreshing) return;
    //画灰色的圆
    CGFloat radius = (self.activityView.width - 5) * 0.5;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, self.activityView.centerX, self.activityView.centerY, radius, 0, M_PI * 2, 0);
    [[UIColor lightGrayColor] set];
    CGContextStrokePath(ctx);
    //画白色的圆
    CGFloat endAngle = ABS(self.delta / 60) * M_PI * 2;
    self.angle = endAngle;
    CGContextAddArc(ctx, self.activityView.centerX, self.activityView.centerY, radius, - M_PI_2 * 3 , endAngle  - M_PI_2 * 3, 0);
    [[UIColor whiteColor] set];
    CGContextStrokePath(ctx);
}

//切换导航条上的内容
- (void)changeLabel:(CGFloat)offset{
    NSInteger count = self.offsets.count;
    CGFloat lastOffset;
    
//    CBYLog(@"%@", self.offsets);
    //若当前刚开始滑动,不做任何处理;
    if (!self.index) return;
    
    /**
     *  防止上拉时同时刷新两天的新闻时有偏差
     */
    if (count > 1 && self.index > 0) {
        lastOffset = [self.offsets[self.index - 1] floatValue];
    }else{
        lastOffset = self.totleOffset;
    }
    
    //判断 如果日期是今天就恢复成--今日热闻
//    CBYLog(@"%@---%@--%@", self.date, self.newsDate, [self nextDay]);
    
    if ([self.newsDate isEqualToString:self.date]) {
        if ((lastOffset - offset) < kChangeLabelMargin) {
            self.titleLabel.hidden = YES;
            self.dateLabel.text = [NSString getDateAndWeekdayWithString:self.date];
            self.dateLabel.hidden = NO;
        }else{
            self.titleLabel.hidden = NO;
            self.dateLabel.hidden = YES;
        }
        return;
    }
    /**
     *  如果不是今天就把datelabel往上顶
     */
    if ((lastOffset - offset) <= CBYNavigationBarHeight) {
        self.lastDateLabel.text = [NSString getDateAndWeekdayWithString:self.date];
        self.lastDateLabel.hidden = NO;
    }else{
        self.lastDateLabel.hidden = YES;
        self.dateLabel.text = self.nextDay;
    }
    self.dateLabel.transform = CGAffineTransformMakeTranslation(0, lastOffset - (CBYNavigationBarHeight + offset));
    if (self.dateLabel.transform.ty > 0) {
        self.dateLabel.transform = CGAffineTransformIdentity;
    }
    self.lastDateLabel.transform = self.dateLabel.transform;
    if (self.lastDateLabel.transform.ty <= self.marginY) {
        self.lastDateLabel.transform = CGAffineTransformMakeTranslation(0, self.marginY);
    }
}

/**
 *  根据日期(20160117)返回 (01月17日 星期天)
 */
- (NSString *)nextDay{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *old = [formatter dateFromString:self.date];
    [formatter setDateFormat:@"MM月dd日 EEEE"];
    NSDate *new = [NSDate dateWithTimeInterval: 60 * 60 * 24 sinceDate:old];
    return [formatter stringFromDate:new];
}

- (void)setNewsDate:(NSString *)newsDate{
    _newsDate = newsDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *old = [formatter dateFromString:newsDate];
    NSDate *new = [NSDate dateWithTimeInterval: - 60 * 60 * 24 sinceDate:old];
    _newsDate = [formatter stringFromDate:new];
}

/**
 *  移除观察者
 */
- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


@end



