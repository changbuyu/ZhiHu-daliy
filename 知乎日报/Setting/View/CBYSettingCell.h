//
//  CBYSettingCell.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/28.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBYItem;
@interface CBYSettingCell : UITableViewCell
@property (nonatomic, strong) CBYItem *item;

+ (instancetype)settingCell:(UITableView *)tableView;
@end
