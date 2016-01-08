//
//  WBStatusesTool.m
//  Weibo
//
//  Created by lbq on 16/1/6.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import "WBStatusesTool.h"
#import "WBStatuses.h"

#import <MJExtension.h>

#define WBLastStatusesPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"lastStatuses.plist"]

@implementation WBStatusesTool

/**
 *  将最新的微博数据存入沙盒中
 */
+ (void)saveStatuses:(NSMutableArray *)array
{
    
    // 取出最新的20条微博
    NSRange range = NSMakeRange(0, array.count >= 20 ? 20 : array.count);
    NSArray *lastArray = [array subarrayWithRange:range];

    // 将模型数组转为字典
    NSArray *dicArray = [WBStatuses mj_keyValuesArrayWithObjectArray:lastArray];
    
    // 将数据存入沙盒中
    [dicArray writeToFile:WBLastStatusesPath atomically:YES];

}

/**
 *  从沙盒中读取上次存入的微博数据
 */
+ (NSArray *)loadStatuses
{
    // 从沙盒取出字典
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:WBLastStatusesPath];
    
    // 将字典数组转为模型数组
    NSArray *array = [WBStatuses mj_objectArrayWithKeyValuesArray:dicArray];
    
    return array;
}

@end
