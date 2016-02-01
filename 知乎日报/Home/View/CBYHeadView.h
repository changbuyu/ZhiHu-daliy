//
//  CBYHeadView.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/13.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
@class CBYNavigationBar;
@interface CBYHeadView : UITableViewHeaderFooterView
@property (nonatomic, copy) NSString *date;

+ (instancetype)headerView:(UITableView *)tableView;

- (void)addObserverToView:(CBYNavigationBar *)navigationBar;
@end
