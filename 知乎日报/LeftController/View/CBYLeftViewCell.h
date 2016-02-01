//
//  CBYLeftViewCell.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/11.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
@class CBYTheme;
@interface CBYLeftViewCell : UITableViewCell
@property (nonatomic, strong) CBYTheme *theme;

+ (instancetype)leftViewCell:(UITableView *)tableView;
@end
