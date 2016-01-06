//
//  WBStatusesTool.h
//  Weibo
//
//  Created by lbq on 16/1/6.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBStatuses.h"

@interface WBStatusesTool : NSObject

/**
 *  将最新的微博数据存入沙盒中
 */
+ (void)saveStatuses:(NSArray *)array;

/**
 *  从沙盒中读取上次存入的微博数据
 *
 *  @return 微博数组
 */
+ (NSArray *)loadStatuses;

@end
