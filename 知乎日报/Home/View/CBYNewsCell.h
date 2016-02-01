//
//  CBYNewsCell.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/16.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBYNews;
@interface CBYNewsCell : UITableViewCell
@property (nonatomic, strong) CBYNews *news;

+ (instancetype)newsCell:(UITableView *)tableView;
@end
