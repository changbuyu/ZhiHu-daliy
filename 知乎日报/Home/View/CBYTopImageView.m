//
//  CBYTopImageView.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/14.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYTopImageView.h"
#import "UIImageView+WebCache.h"

@interface CBYTopImageView()
@property (nonatomic, assign) CGFloat oldOffset;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIVisualEffectView *effectView;
@end

@implementation CBYTopImageView

- (instancetype)init{
    if (self = [super init]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.backgroundColor = CBYCOLOR(24, 123, 200);
        /**
         *  添加毛玻璃效果
         */
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView= [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.alpha = 0.8;
        self.effectView = effectView;
        [self addSubview:effectView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.effectView.frame = self.bounds;
}

- (void)setThumbnail:(NSString *)thumbnail{
    _thumbnail = thumbnail;
    [self sd_setImageWithURL:[NSURL URLWithString:self.thumbnail]];
}

- (void)addObserveTo:(UIScrollView *)scrollView{
    self.oldOffset = scrollView.contentOffset.y;
    self.scrollView = scrollView;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    CGPoint new = [change[@"new"] CGPointValue];
    CGFloat delta = self.oldOffset - new.y;
    if (delta < 0) return;
    self.height = CBYNavigationBarHeight + delta;
    CGFloat currentAlpha = 0.8 - delta / CBYNavigationBarHeight;
    self.effectView.alpha = MAX(0, currentAlpha);
}

-(void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end

