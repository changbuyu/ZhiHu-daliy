//
//  CBYItem.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/28.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CBYItemSelectedBlock)();

@interface CBYItem : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) CBYItemSelectedBlock option;

- (instancetype)initIcon:(NSString *)icon title:(NSString *)title;
- (instancetype)initTitle:(NSString *)title;
@end
