//
//  CBYLeftViewCell.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/11.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYLeftViewCell.h"
#import "CBYTheme.h"
static NSString *const reusedID = @"cell";
static NSInteger const kAccessoryViewMargin = 20;
static NSInteger const kAccessoryWH = 27;


@implementation CBYLeftViewCell

+ (instancetype)leftViewCell:(UITableView *)tableView{
    CBYLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (!cell) {
        cell = [[CBYLeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
        cell.accessoryView = nil;
    }
    [cell addAccessoryView];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor =CBYCOLOR(31, 38, 46);
        self.textLabel.textColor = CBYCOLOR(128, 133, 140);
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addAccessoryView{
    UIButton *access = [UIButton buttonWithType:UIButtonTypeCustom];
    access.adjustsImageWhenHighlighted = NO;
    access.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat accessWH = kAccessoryWH;
    CGFloat accessX = self.width - accessWH - kAccessoryViewMargin;
    CGFloat accessY = (self.height - accessWH) * 0.5;
    access.frame = CGRectMake(accessX, accessY, accessWH, accessWH);
    self.accessoryView = access;
    [access setImage:[UIImage imageNamed:@"Home_Arrow"] forState:UIControlStateNormal];
    [access addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeState:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (void)setTheme:(CBYTheme *)theme{
    _theme = theme;
    self.textLabel.text = theme.name;
    
}

@end
