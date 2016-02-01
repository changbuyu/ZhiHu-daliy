//
//  CBYSettingCell.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/28.
//  Copyright © 2016年 CBY. All rights reserved.
//
#define CBYDEFAULTS [NSUserDefaults standardUserDefaults]
#import "CBYSettingCell.h"
#import "CBYPubilc.h"
#import "CBYItem.h"
#import "CBYArrowItem.h"
#import "CBYSwitchItem.h"
static NSString *const reusedID = @"cell";

@interface CBYSettingCell ()
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UISwitch *switchView;
@end

@implementation CBYSettingCell

- (UIImageView *)arrowView{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Editor_Arrow"]];
    }
    return _arrowView;
}

- (UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = CBYCOLOR(23, 124, 200);
        [_switchView addTarget:self action:@selector(saveValue) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

+ (instancetype)settingCell:(UITableView *)tableView{
    CBYSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (!cell) {
        cell = [[CBYSettingCell alloc] init];
    }
    return cell;
}

- (void)saveValue{
    [CBYDEFAULTS setBool:self.switchView.isOn forKey:self.item.title];
    [CBYDEFAULTS synchronize];
}

- (void)setItem:(CBYItem *)item{
    _item = item;
    
    self.textLabel.text = item.title;
    
    if (item.icon) {
        self.imageView.image = [UIImage imageNamed:item.icon];
    }
    
    if ([item isKindOfClass:[CBYArrowItem class]]) {
        self.accessoryView = self.arrowView;
    }else if ([item isKindOfClass:[CBYSwitchItem class]]){
        self.accessoryView = self.switchView;
        self.switchView.on = [CBYDEFAULTS valueForKey:item.title];
    }else{
        self.accessoryView = nil;
    };
}
@end
