//
//  WBStatusesFrame.h
//  Weibo
//
//  Created by lbq on 16/1/8.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//  1.数据模型
//  2.所有控件的frame
//  3.cell的高度

#import <Foundation/Foundation.h>

#import "WBStatuses.h"


// 昵称字体大小
#define WBstatusesCellscreenNameFont    [UIFont systemFontOfSize:17]

// 时间字体大小
#define WBstatusesCellTimeFont    [UIFont systemFontOfSize:17]

// 来源字体大小
#define WBstatusesCellSourceFont    [UIFont systemFontOfSize:17]

// 微博正文字体大小
#define WBstatusesCellcontentFont    [UIFont systemFontOfSize:17]


@interface WBStatusesFrame : NSObject

/** 微博数据模型 */
@property (nonatomic, strong)  WBStatuses *statuses;

/** 原创微博整体 */
@property (nonatomic, assign)  CGRect originalViewFrame;

/** 头像 */
@property (nonatomic, assign)  CGRect iconViewFrame;

/** 昵称 */
@property (nonatomic, assign)  CGRect screenNameLabelFrame;

/** VIP等级 */
@property (nonatomic, assign)  CGRect vipLevelViewFrame;

/** 时间 */
@property (nonatomic, assign)  CGRect timeLabelFrame;

/** 来自哪个来源 */
@property (nonatomic, assign)  CGRect sourceLabelFrame;

/** 微博正文 */
@property (nonatomic, assign)  CGRect contentLabelFrame;

/** 微博配图 */
@property (nonatomic, assign)  CGRect contentPhotoViewFrame;


/** 转发微博整体 */

/** cell高度 */
@property (nonatomic, assign)  CGFloat cellHeight;
@end
