//
//  CBYCommentCell.h
//  知乎日报
//
//  Created by 常布雨 on 16/1/30.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYPubilc.h"
UIKIT_EXTERN NSString *const CBYCommentCellReusedID;

@class CBYComment, CBYCommentCell;
@protocol CBYCommentCellDelegate <NSObject>

@optional
- (void)commentCell:(CBYCommentCell *)commentCell open:(BOOL)open;

@end

@interface CBYCommentCell : UITableViewCell
/** 评论 */
@property (nonatomic, strong) CBYComment *comment;
/** 代理 */
@property (nonatomic, weak) id<CBYCommentCellDelegate> deleagate;
/** reply的评论 */
@property (nonatomic, weak) UILabel *replyLabel;

+ (instancetype)commentCell:(UITableView *)tableView;
@end
