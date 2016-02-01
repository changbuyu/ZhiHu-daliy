//
//  CBYNewsCell.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/16.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYNewsCell.h"
#import "Masonry.h"
#import "CBYNews.h"
#import "UIImageView+WebCache.h"
static NSString *const CBYReusedID = @"cell";

@interface CBYNewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (nonatomic, weak) UIImageView *morePic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginToImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@end

@implementation CBYNewsCell

+ (instancetype)newsCell:(UITableView *)tableView{
    CBYNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CBYReusedID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CBYNewsCell" owner:self options:nil] lastObject];
    }
    UIImageView *images = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_Morepic"]];
    [cell.pictureView addSubview:images];
    cell.morePic = images;
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.morePic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(14);
        make.right.equalTo(self.pictureView.mas_right);
        make.bottom.equalTo(self.pictureView.mas_bottom);
    }];
}

- (void)setNews:(CBYNews *)news{
    _news = news;
    
    self.titleLabel.text = news.title;
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:news.imageStr]];
    if (news.isMultipic) {
        self.morePic.hidden = NO;
    }else{
        self.morePic.hidden = YES;
    }
    
    if (news.images) {
        self.imageWidth.constant = 80;
        self.marginToImage.constant = 10;
    }else{
        self.imageWidth.constant = 0;
        self.marginToImage.constant = 0;
    }
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}
@end
