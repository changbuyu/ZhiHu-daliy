//
//  CBYToolbar.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYToolbar.h"
#import "CBYDetailTool.h"
#import "CBYExtra.h"
#import "Masonry.h"
#import "CBYNewsTool.h"
static const NSUInteger kButtonNumbers = 5;

@interface CBYToolbar ()
@property (nonatomic, weak) UIButton *previousButton;
@property (nonatomic, weak) UIButton *nextButton;
@property (nonatomic, weak) UIButton *forwardButton;
@property (nonatomic, weak) UIButton *commentButton;
@property (nonatomic, weak) UILabel *commentLabel;
@property (nonatomic, weak) UIView *divide;
@end


@implementation CBYToolbar

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Browser_Navibar"]];
        UIView *divide = [[UIView alloc] init];
        divide.backgroundColor = [UIColor blackColor];
        divide.alpha = 0.1;
        [self addSubview:divide];
        self.divide = divide;
    }
    return self;
}

- (void)addButtonWithName:(NSString *)imageName highImage:(NSString *)highImage selectedImage:(NSString *)selectedImage disabledImage:(NSString *)disabledImage type:(CBYToolbarButtonType)type{
    UIButton *button = [[UIButton alloc] init];
    button.imageView.contentMode = UIViewContentModeCenter;
    [button setImage:[UIImage imageNamed: imageName] forState:UIControlStateNormal];
    button.tag = type;
    
    if (highImage) {
        [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    }
    if (selectedImage) {
        [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    }
    if (disabledImage) {
        [button setImage:[UIImage imageNamed:disabledImage] forState:UIControlStateDisabled];
    }
    
    if (type == CBYToolbarButtonTypeAttitude) {
        UILabel *label = [self addLabelWithColor:[UIColor grayColor] font:8];
        [button addSubview:label];
        self.attitudeLabel = label;
        self.attitudeButton = button;
    }else if (type == CBYToolbarButtonTypeComment){
        UILabel *label = [self addLabelWithColor:[UIColor whiteColor] font:8];
        [button addSubview:label];
        self.commentLabel = label;
        self.commentButton = button;
    }else if (type == CBYToolbarButtonTypeForward){
        self.forwardButton = button;
        button.enabled = NO;
    }else if (type == CBYToolbarButtonTypePrevious){
        self.previousButton = button;
        button.enabled = NO;
    }else if (type == CBYToolbarButtonTypeNext){
        self.nextButton = button;
    }
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (UILabel *)addLabelWithColor:(UIColor *)color font:(NSUInteger)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.divide.frame = self.bounds;
    self.divide.height = 1;
    self.divide.y = -0.5;
    
    CGFloat buttonW = CBYSCREENW / kButtonNumbers;
    CGFloat buttonH = self.height;
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    
    NSUInteger idx = 0;
    for (UIView *obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            buttonX = buttonW * idx;
            obj.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            idx ++;
        }
    }
    
    [self.attitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.equalTo(self.attitudeButton);
        make.left.equalTo(self.attitudeButton.mas_centerX);
        make.bottom.equalTo(self.attitudeButton.mas_centerY);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentButton).with.multipliedBy(0.81);
        make.top.equalTo(self.commentButton).with.offset(6);
        make.left.equalTo(self.commentButton.mas_centerX).with.offset(- 1);
        make.bottom.equalTo(self.commentButton.mas_centerY).with.offset(- 3);
    }];
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == CBYToolbarButtonTypeAttitude) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            self.oldCounts = self.attitudeLabel.text;
            [UIView animateWithDuration:CBYAnimationDuration animations:^{
                self.attitudeLabel.textColor = CBYCOLOR(32, 180, 241);
                self.attitudeLabel.text = [NSString stringWithFormat:@"%ld", ([self.oldCounts integerValue] + 1)];
                sender.imageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:CBYAnimationDuration animations:^{
                    sender.imageView.transform = CGAffineTransformIdentity;
                }];
            }];
        }else{
            self.attitudeLabel.textColor = [UIColor grayColor];
            self.attitudeLabel.text = self.oldCounts;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(toolBar:buttonType:)]) {
        [self.delegate toolBar:self buttonType:sender.tag];
    }
}

- (void)setIndex:(NSNumber *)index{
    _index = index;
    
    if ([CBYNewsTool isTheLastNewsWithIndex:index]) {
        self.nextButton.enabled = NO;
    }else{
        self.nextButton.enabled = YES;
    }
    
    [CBYDetailTool getExtraWithIndex:self.index success:^(id obj, NSString *css) {
        CBYExtra *extra = (CBYExtra *)obj;
        self.attitudeLabel.text = [NSString stringWithFormat:@"%@", extra.popularity];
        self.commentLabel.text = [NSString stringWithFormat:@"%@", extra.comments];
    }];
    
}

- (void)setCanGoNext:(BOOL)canGoNext{
    _canGoNext = canGoNext;
    if (!canGoNext) {
        self.forwardButton.enabled = NO;
    }else{
        self.forwardButton.enabled = YES;
    }
}

- (void)setCanGoPrevious:(BOOL)canGoPrevious{
    _canGoPrevious = canGoPrevious;
    if (!canGoPrevious) {
        self.previousButton.enabled = NO;
    }else{
        self.previousButton.enabled = YES;
    }
}
@end
