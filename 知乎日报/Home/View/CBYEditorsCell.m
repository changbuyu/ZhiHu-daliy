//
//  CBYEditorsCell.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/17.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYEditorsCell.h"
#import "CBYEditor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
static NSString *const ID = @"editor";
static const CGFloat kEditorAvatarMargin = 10;
static const CGFloat kIconViewWH = 20;

@interface CBYIconView : UIImageView
@property (nonatomic, copy) NSString *icon;
@end

@implementation CBYIconView
- (instancetype)init{
    if (self = [super init]) {
        self.contentMode = UIViewContentModeScaleToFill;
        self.layer.cornerRadius = kIconViewWH * 0.5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setIcon:(NSString *)icon{
    _icon = icon;
    [self sd_setImageWithURL:[NSURL URLWithString:icon]];
}
@end

@interface CBYEditorsCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) NSMutableArray *iconViews;
@end

@implementation CBYEditorsCell

- (NSMutableArray *)iconViews{
    if (!_iconViews) {
        _iconViews = [NSMutableArray array];
    }
    return _iconViews;
}

+ (instancetype)editorsCell:(UITableView *)tableView{
    CBYEditorsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CBYEditorsCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setEditors:(NSArray *)editors{
    _editors = editors;
    [self.iconViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.iconViews removeAllObjects];
    for (int i = 0; i < self.editors.count; i++) {
        CBYIconView *iconView = [[CBYIconView alloc] init];
        iconView.icon = [self.editors[i] avatar];
        [self.iconViews addObject:iconView];
        [self.contentView addSubview:iconView];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    /**
     *  使分割线占据整个屏幕
     */
    [self setLayoutMargins:UIEdgeInsetsZero];
    [self setSeparatorInset:UIEdgeInsetsZero];
    /**
     *  autolayout不要与frame混用.
     */
    if (self.editors.count) {
        __block UIView *leftView = self.label;
        [self.iconViews enumerateObjectsUsingBlock:^(CBYIconView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.label);
                make.width.and.height.mas_offset(kIconViewWH);
                make.left.equalTo(leftView.mas_right).with.offset(kEditorAvatarMargin);
                leftView = obj;
            }];
        }];
    }
}


@end
