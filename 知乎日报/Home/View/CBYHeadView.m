//
//  CBYHeadView.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/13.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYHeadView.h"
#import "NSString+Extension.h"
#import "CBYNavigationBar.h"
@interface CBYHeadView ()
@property (nonatomic, strong) CBYNavigationBar *navigationBar;
@property (nonatomic, weak) UILabel *dateLabel;
@end

@implementation CBYHeadView

+ (instancetype)headerView:(UITableView *)tableView{
    static NSString * headerID = @"header";
    CBYHeadView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!header) {
        header = [[CBYHeadView alloc] initWithReuseIdentifier:headerID];
    }
    header.textLabel.text = nil;
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = CBYCOLOR(24, 123, 200);
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.dateLabel.frame = self.bounds;
}

- (void)setDate:(NSString *)date{
    _date = date;
    self.dateLabel.text = [NSString getDateAndWeekdayWithString:date];;
}
/**
 *  添加观察者,在适当的时候清除label
 */
- (void)addObserverToView:(CBYNavigationBar *)navigationBar{
    [navigationBar addObserver:self forKeyPath:@"lastDateLabel.hidden" options:NSKeyValueObservingOptionNew context:nil];
    self.navigationBar = navigationBar;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    self.dateLabel.hidden = ![change[@"new"] integerValue];
}

- (void)dealloc{
    [self.navigationBar removeObserver:self forKeyPath:@"lastDateLabel.hidden"];
}
@end
