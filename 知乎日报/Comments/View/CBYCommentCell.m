//
//  CBYCommentCell.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/30.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYCommentCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "CBYComment.h"
#import "NSString+Extension.h"
NSString *const CBYCommentCellReusedID = @"CBYCommentCellReusedID";
const CGFloat kCommentCellMargin = 10;

@interface CBYCommentCell ()
/** 头像 30x30 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 bold 10号 */
@property (nonatomic, weak) UILabel *nameLabel;
/** likes */
@property (nonatomic, weak) UIButton *likesButton;
/** 评论内容 */
@property (nonatomic, weak) UILabel *commentLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 展开按钮 */
@property (nonatomic, weak) UIButton *spreadButton;
/** 分割线 */
@property (nonatomic, weak) UIView *divide;
/** 评论是否展开 */
@property (nonatomic, assign, getter = isOpen) BOOL open;
@end


@implementation CBYCommentCell

+ (instancetype)commentCell:(UITableView *)tableView{
    CBYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CBYCommentCellReusedID];
    if (!cell) {
        cell = [[CBYCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CBYCommentCellReusedID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {        
        [self setupViews];
        [self addAutoLayout];
        
    }
    return self;
}

- (void)setupViews{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    self.iconView = imageView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont boldSystemFontOfSize:10];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIButton *button = [[UIButton alloc] init];
    button.contentMode = UIViewContentModeRight;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2, 3, 0, 0)];
    [button setImage:[UIImage imageNamed:@"Comment_Vote"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Comment_Voted"] forState:UIControlStateSelected];
    button.userInteractionEnabled = NO;
    [self.contentView addSubview:button];
    self.likesButton = button;
    
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.font = [UIFont systemFontOfSize:10];
    commentLabel.numberOfLines = 0;
    [self.contentView addSubview:commentLabel];
    self.commentLabel = commentLabel;
    
    UILabel *replyLabel = [[UILabel alloc] init];
    replyLabel.numberOfLines = 2;
    [self.contentView addSubview:replyLabel];
    self.replyLabel = replyLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:8];
    timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIButton *spread = [[UIButton alloc] init];
    spread.backgroundColor = CBYCOLOR(106, 200, 247);
    spread.adjustsImageWhenHighlighted = NO;
    [spread setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    spread.titleLabel.font = [UIFont systemFontOfSize:10];
    spread.titleLabel.textColor = [UIColor darkGrayColor];
    [spread setTitle:(self.isOpen ? @"收起" : @"展开") forState:UIControlStateNormal];
    [self.contentView addSubview:spread];
    [spread addTarget:self action:@selector(spreadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.spreadButton = spread;
    
    UIView *divide = [[UIView alloc] init];
    divide.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:divide];
    self.divide = divide;
}

- (void)addAutoLayout{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(30);
        make.left.equalTo(self.contentView).with.offset(kCommentCellMargin);
        make.top.equalTo(self.contentView).with.offset(kCommentCellMargin);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(kCommentCellMargin);
        make.left.equalTo(self.iconView.mas_right).with.offset(kCommentCellMargin);
        make.right.equalTo(self.contentView).with.offset(- kCommentCellMargin);
    }];
    
    [self.likesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).with.offset(-kCommentCellMargin);
        make.width.mas_equalTo(30);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).with.offset(- kCommentCellMargin);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(kCommentCellMargin);
    }];
    
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.width.equalTo(self.commentLabel);
        make.top.equalTo(self.commentLabel.mas_bottom).with.offset(kCommentCellMargin);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.replyLabel.mas_bottom).with.offset(kCommentCellMargin);
        make.bottom.equalTo(self.contentView).with.offset(- kCommentCellMargin);
    }];

    [self. spreadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.right.equalTo(self.contentView).with.offset(- kCommentCellMargin);
        make.height.mas_equalTo(15);
    }];

    [self.divide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-0.5);
        make.height.mas_equalTo(1);
    }];
}

- (void)updateConstraints{
    [self.replyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.width.equalTo(self.commentLabel);
        
        if (self.replyLabel.hidden) {
            make.top.equalTo(self.commentLabel.mas_bottom);
            make.height.mas_equalTo(CGFLOAT_MIN);
        }else{
            make.top.equalTo(self.commentLabel.mas_bottom).with.offset(kCommentCellMargin);
        }

    }];
    
    [super updateConstraints];
}

- (void)setComment:(CBYComment *)comment{
    _comment = comment;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:[UIImage imageNamed:@"Comment_Avatar"]];
    
    self.nameLabel.text = comment.author;
    
    [self.likesButton setTitle:[NSString stringWithFormat:@"%@", comment.likes] forState:UIControlStateNormal] ;
    
    self.commentLabel.text = comment.content;
    
    if (!comment.reply_to) {
        self.replyLabel.hidden = YES;
        self.spreadButton.hidden = YES;
    }else{
        self.replyLabel.hidden = NO;
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] init];
        
        NSString *str = [NSString stringWithFormat:@"//%@:%@", comment.reply_to.author, comment.reply_to.content];
        NSRange range = [str localizedStandardRangeOfString:@":"];
        NSRange nameRange = NSMakeRange(0, range.location);
        NSAttributedString *nameStr = [[NSAttributedString alloc] initWithString:[str substringWithRange:nameRange] attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:10], NSForegroundColorAttributeName : [UIColor blackColor]}];
        [attributeStr appendAttributedString:nameStr];
        
        NSAttributedString *contentStr = [[NSAttributedString alloc] initWithString:[str substringWithRange:NSMakeRange(range.location + 1, str.length - nameRange.length -1)] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : [UIColor grayColor]}];
        [attributeStr appendAttributedString:contentStr];
        self.replyLabel.attributedText = attributeStr;
    }
  
    self.timeLabel.text = [NSString stringWithFormat:@"%@", comment.timeStr];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
//    MASAttachKeys(_iconView, _nameLabel, _timeLabel, _replyLabel, _commentLabel, _spreadButton, _likesButton);
}

- (void)spreadButtonClick{
    self.open = !self.isOpen;
    if ([self.deleagate respondsToSelector:@selector(commentCell:open:)]) {
        [self.deleagate commentCell:self open: self.isOpen];
    }
}
/**
 *  如果回复已经显示完全,就使展开button隐藏
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.replyLabel.hidden && !self.isOpen) {
        CGSize size = [self.replyLabel.text sizeWithFontSize:10 andMaxX:_commentLabel.width];
        if (size.height < _replyLabel.height) {
            _spreadButton.hidden = YES;
        }else{
            _spreadButton.hidden = NO;
        }
    }
}

@end
