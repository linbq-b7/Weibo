//
//  WBStatusesCell.h
//  Weibo
//
//  Created by lbq on 16/1/8.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBStatusesFrame;

@interface WBStatusesCell : UITableViewCell

/**
 *  创建cell
 */
+ (instancetype)cellWithtableView:(UITableView *)tableView;

/** 微博模型Frame */
@property (nonatomic, strong)  WBStatusesFrame *statusesFrame;


@end
