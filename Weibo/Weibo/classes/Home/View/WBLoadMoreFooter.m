//
//  WBLoadMoreFooter.m
//  Weibo
//
//  Created by lbq on 16/1/6.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import "WBLoadMoreFooter.h"

@implementation WBLoadMoreFooter

/**
 *  下拉加载控件
 */
+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WBLoadMoreFooter" owner:nil options:nil] firstObject];
}

@end
