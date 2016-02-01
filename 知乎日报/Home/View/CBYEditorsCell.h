//
//  CBYEditorsCell.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/17.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBYEditorsCell : UITableViewCell
@property (nonatomic, strong) NSArray *editors;

+ (instancetype)editorsCell:(UITableView *)tableView;
@end
