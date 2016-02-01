//
//  CBYHeadButton.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/31.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBYHeadButton : UIButton
/** 标题 */
@property (nonatomic, weak) UILabel *textLabel;
/** 图片 */
@property (nonatomic, weak) UIImageView *iconView;
@end
