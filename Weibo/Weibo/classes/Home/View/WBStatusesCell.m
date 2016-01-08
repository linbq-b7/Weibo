//
//  WBStatusesCell.m
//  Weibo
//
//  Created by lbq on 16/1/8.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import "WBStatusesCell.h"
#import "WBStatusesFrame.h"
#import "WBUser.h"
#import "WBStatusesPhoto.h"
#import <UIImageView+WebCache.h>

@interface WBStatusesCell()
/** 原创微博整体 */
@property (nonatomic, weak)  UIView *originalView;

/** 头像 */
@property (nonatomic, weak)  UIImageView *iconView;

/** 昵称 */
@property (nonatomic, weak)  UILabel *screenNameLabel;

/** VIP等级 */
@property (nonatomic, weak)  UIImageView *vipLevelView;

/** 时间 */
@property (nonatomic, weak)  UILabel *timeLabel;

/** 来自哪个来源 */
@property (nonatomic, weak)  UILabel *sourceLabel;

/** 微博正文 */
@property (nonatomic, weak)  UILabel *contentLabel;

/** 微博配图 */
@property (nonatomic, weak)  UIImageView *contentPhotoView;

@end

@implementation WBStatusesCell

/**
 *  创建cell
 */
+ (instancetype)cellWithtableView:(UITableView *)tableView {
    static NSString *ID = @"statuses";
    WBStatusesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WBStatusesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  初始化cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1. 将有可能显 的所有 控件都添加到contentView中
        // 2. 顺便设置 控件的 属性一次性的设置:字体、 字颜 、 背景
        /** 原创微博整体 */
        UIView *originalView = [[UIView alloc]init];
        [self.contentView addSubview:originalView];
        self.originalView = originalView;
        
        /** 头像 */
        UIImageView *iconView = [[UIImageView alloc]init];
        [originalView addSubview:iconView];
        self.iconView = iconView;
        self.iconView.contentMode = UIViewContentModeCenter;
        
        /** 昵称 */
        UILabel *screenNameLabel = [[UILabel alloc]init];
        [originalView addSubview:screenNameLabel];
        self.screenNameLabel = screenNameLabel;
        
        /** VIP等级 */
        UIImageView *vipLevelView = [[UIImageView alloc]init];
        [originalView addSubview:vipLevelView];
        self.vipLevelView = vipLevelView;
        self.vipLevelView.contentMode = UIViewContentModeCenter;
        
        /** 时间 */
        UILabel *timeLabel = [[UILabel alloc]init];
        [originalView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        /** 来自哪个来源 */
        UILabel *sourceLabel = [[UILabel alloc]init];
        [originalView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        /** 微博正文 */
        UILabel *contentLabel = [[UILabel alloc]init];
        contentLabel.numberOfLines = 0;
        [originalView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        /** 微博配图 */
        UIImageView *contentPhotoView = [[UIImageView alloc]init];
        [originalView addSubview:contentPhotoView];
        self.contentPhotoView = contentPhotoView;
        
        
        
       
        
    }
    return self;
}

- (void)setStatusesFrame:(WBStatusesFrame *)statusesFrame
{
    _statusesFrame = statusesFrame;
    
    WBStatuses *statuses = statusesFrame.statuses;
    WBUser *user = statuses.user;
    
    // 1.将frame模型传递给cell
    
    /** 原创微博整体 */
    self.originalView.frame = statusesFrame.originalViewFrame;
    
    /** 头像 */
    self.iconView.frame = statusesFrame.iconViewFrame;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    /** 昵称 */
    self.screenNameLabel.frame = statusesFrame.screenNameLabelFrame;
    self.screenNameLabel.text = user.screen_name;
    
    /** VIP等级 */
    self.vipLevelView.frame = statusesFrame.vipLevelViewFrame;
    if (user.vip) {
        self.vipLevelView.hidden = NO;
        self.vipLevelView.image = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank]];
        self.screenNameLabel.textColor = [UIColor orangeColor];
    } else {
        self.vipLevelView.hidden = YES;
        self.screenNameLabel.textColor = [UIColor blackColor];
    }
    
    /** 时间 */
    self.timeLabel.frame = statusesFrame.timeLabelFrame;
    self.timeLabel.text = statuses.created_at;
    
    /** 来自哪个来源 */
    self.sourceLabel.frame = statusesFrame.sourceLabelFrame;
    self.sourceLabel.text = statuses.source;
    
    /** 微博正文 */
    self.contentLabel.frame = statusesFrame.contentLabelFrame;
    self.contentLabel.text = statuses.text;
    
    /** 微博配图 */
    self.contentPhotoView.frame = statusesFrame.contentPhotoViewFrame;
    if (statuses.pic_urls.count) {
        self.contentPhotoView.hidden = NO;
        WBStatusesPhoto *photo = [statuses.pic_urls firstObject];
        [self.contentPhotoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    } else {
         self.contentPhotoView.hidden = YES;
    }
    
    
    
    // 2.cell根据frame模型给 控件设置frame,根据数据模型给控件设置数据
    // 3.cell根据数据模型决定显示和隐藏哪些控件
}

@end
