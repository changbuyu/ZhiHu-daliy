//
//  CBYEditor.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/17.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBYEditor : NSObject
@property (nonatomic, copy) NSString *url;
/** cell的detaillabel */
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *name;
@end
