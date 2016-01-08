//
//  WBAccountTool.h
//  Weibo
//
//  Created by lbq on 16/1/5.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBAccount.h"

@interface WBAccountTool : NSObject

/**
 *  将微博账户信息存入沙盒中
 *
 *  @param account 账户信息模型
 */
+ (void)saveAccount:(WBAccount *)account;

/**
 *  获取沙盒中的微博账户信息
 *
 *  @return 微博账户信息模型
 */
+ (WBAccount *)account;

/**
 *  注销,将微博账号信息存放文件删除
 */
+ (void)LogOut;

@end
