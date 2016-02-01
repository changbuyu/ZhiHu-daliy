//
//  CBYDetail.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBYSection;
@interface CBYDetail : NSObject
/**body  HTML 格式的新闻*/
@property (nonatomic, copy) NSString *body;
/**image-source  图片的内容提供方*/
@property (nonatomic, copy) NSString *image_source;
/**title  新闻标题*/
@property (nonatomic, copy) NSString *title;
/**image  图片*/
@property (nonatomic, copy) NSString *image;
/**share_url  分享至 SNS 用的 URL*/
@property (nonatomic, copy) NSString *share_url;
/**id  新闻的 id*/
@property (nonatomic, strong) NSNumber *index;
/**css  供手机端的 WebView(UIWebView) 使用*/
@property (nonatomic, strong) NSArray *css;
/** web 下方的按钮 */
@property (nonatomic, strong) CBYSection *section;
/** type */
@property (nonatomic, strong) NSNumber *type;
/** ga_prefix */
@property (nonatomic, copy) NSString *ga_prefix;
/** 推荐者 */
@property (nonatomic, strong) NSArray *recommenders;
@end
