//
//  CBYThemeDetail.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/17.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYThemeDetail : NSObject
@property (nonatomic, strong) NSArray *stories;

@property (nonatomic, copy) NSString *describe;

@property (nonatomic, copy) NSString *background;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *color;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, strong) NSArray *editors;

@property (nonatomic, copy) NSString *image_source;
@end
