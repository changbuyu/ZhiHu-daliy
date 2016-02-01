//
//  CBYBottomBar.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/30.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYBottomBar.h"
NSString *const CBYBottomBarBackButton = @"CBYBottomBarBackButton";

@implementation CBYBottomBar

- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CBYBottomBar" owner:self options:nil] lastObject];
    }
    return self;
}

- (IBAction)backButtonClick {
    [self buttonClickWithName:CBYBottomBarBackButton];
}

- (IBAction)commentButtonClick:(UIButton *)sender {
    [self buttonClickWithName:nil];
}

- (void)buttonClickWithName:(NSString *)name{
    if ([self.delegate respondsToSelector:@selector(bottomBar:name:)]) {
        [self.delegate bottomBar:self name:name];
    }
}
@end
