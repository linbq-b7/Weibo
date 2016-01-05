//
//  WBAccountTool.m
//  Weibo
//
//  Created by lbq on 16/1/5.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import "WBAccountTool.h" 
#import "WBAccount.h"
@implementation WBAccountTool

#define WBAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"account.plist"]

/**
 *  将微博账户信息存入沙盒中
 *
 *  @param account 账户信息模型
 */
+ (void)saveAccount:(WBAccount *)account
{
    // 自定义对象存入沙盒使用NSKeyedArchiver
    [NSKeyedArchiver archiveRootObject:account toFile:WBAccountPath];
    
}

/**
 *  获取沙盒中的微博账户信息
 *
 *  @return 微博账户信息模型
 */
+ (WBAccount *)account
{
    WBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:WBAccountPath];
    
    // 判断账号是否过期
    long long expires_in = [account.expires_in longLongValue];
    NSDate *expires_time = [account.created_time dateByAddingTimeInterval:expires_in] ;
    NSDate *now_time = [NSDate date];
    NSComparisonResult result = [now_time compare:expires_time];
    if (result == NSOrderedDescending) {
        // 当前时间大于过期时间,账户过期
        return nil;
    }
    return account;
}

@end
