//
//  WBStatusesFrame.m
//  Weibo
//
//  Created by lbq on 16/1/8.
//  Copyright © 2016年 linbq-b7. All rights reserved.

#import "WBStatusesFrame.h"
#import "WBUser.h"

// cell边距
#define WBStatusesCellBorderW 10;

@class WBStatuses;
@implementation WBStatusesFrame

- (void)setStatuses:(WBStatuses *)statuses
{
    _statuses = statuses;
    
    WBUser *user = statuses.user;

    /** 原创微博*/
    /** 头像 */
    CGFloat iconViewX = WBStatusesCellBorderW;
    CGFloat iconViewY = WBStatusesCellBorderW;
    CGFloat iconViewWH = 50;
    self.iconViewFrame = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    /** 昵称 */
    CGFloat screenNameLabelX = CGRectGetMaxX(self.iconViewFrame) + WBStatusesCellBorderW;
    CGFloat screenNameLabelY = iconViewY;
    CGSize screenNameLabelSize =  [NSString sizeWithText:user.screen_name font:WBstatusesCellscreenNameFont];
    self.screenNameLabelFrame = (CGRect){{screenNameLabelX, screenNameLabelY}, screenNameLabelSize};
    
    /** VIP等级 */
    CGFloat vipLevelViewX = CGRectGetMaxX(self.screenNameLabelFrame) + WBStatusesCellBorderW;
    CGFloat vipLevelViewY = screenNameLabelY;
    CGFloat vipLevelViewW = 15;
    CGFloat vipLevelViewH = screenNameLabelSize.height;
    self.vipLevelViewFrame = CGRectMake(vipLevelViewX, vipLevelViewY, vipLevelViewW, vipLevelViewH);
    
    
    /** 时间 */
    CGFloat timeLabelX = screenNameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(self.screenNameLabelFrame) + WBStatusesCellBorderW;
    CGSize timeLabelSize =  [NSString sizeWithText:statuses.created_at font:WBstatusesCellTimeFont];
    self.timeLabelFrame = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};

    
    /** 来自哪个来源 */
    CGFloat sourceLabelX = CGRectGetMaxX(self.timeLabelFrame) + WBStatusesCellBorderW;
    CGFloat sourceLabelY = timeLabelY;
    CGSize sourceLabelSize =  [NSString sizeWithText:statuses.source font:WBstatusesCellSourceFont];
    self.sourceLabelFrame = (CGRect){{sourceLabelX, sourceLabelY}, sourceLabelSize};
    
    /** 微博正文 */
    CGFloat contentLabelX = iconViewX;
    CGFloat contentLabelY = MAX(CGRectGetMaxY(self.iconViewFrame), CGRectGetMaxY(self.timeLabelFrame)) + WBStatusesCellBorderW;
    CGFloat textWidth = [UIScreen mainScreen].bounds.size.width - 2 * WBStatusesCellBorderW;
    CGSize contentLabelSize =  [NSString sizeWithText:statuses.text font:WBstatusesCellcontentFont textWidth:textWidth];
    self.contentLabelFrame = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};
    
    /** 微博配图 */
    CGFloat originalViewH = 0;
    if (statuses.pic_urls.count) {
        // 有配图
        CGFloat contentPhotoViewX = iconViewX;
        CGFloat contentPhotoViewY = CGRectGetMaxY(self.contentLabelFrame) + WBStatusesCellBorderW;;
        CGFloat contentPhotoViewWH = 50;
        self.contentPhotoViewFrame = CGRectMake(contentPhotoViewX, contentPhotoViewY, contentPhotoViewWH, contentPhotoViewWH);
        originalViewH = CGRectGetMaxY(self.contentPhotoViewFrame);
    } else {
        // 无配图
        originalViewH = CGRectGetMaxY(self.contentLabelFrame);
    }
   
    
    /** 原创微博整体 */
    CGFloat originalViewX = 0;
    CGFloat originalViewY = 0;
    CGFloat originalViewW = [UIScreen mainScreen].bounds.size.width;
    
    self.originalViewFrame = CGRectMake(originalViewX, originalViewY, originalViewW, originalViewH);
    
    /** cell高度 */
    self.cellHeight = CGRectGetMaxY(self.originalViewFrame) + WBStatusesCellBorderW;
    
    
    
}

@end
