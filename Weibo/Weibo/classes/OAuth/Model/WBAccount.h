//
//  WBAccount.h
//  Weibo
//
//  Created by lbq on 16/1/5.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBAccount : NSObject <NSCoding>
/** access_token	string	用于调用access_token，接口获取授权后的access token */
@property (nonatomic ,copy)  NSString *access_token;

/** expires_in	string	access_token的生命周期，单位是秒数 */
@property (nonatomic ,copy)  NSNumber *expires_in;

/** 存储账号的时间 */
@property (nonatomic ,strong)  NSDate *created_time;

/** uid	string	当前授权用户的UID */
@property (nonatomic ,copy)  NSString *uid;

/** 用户昵称 */
@property (nonatomic ,copy)  NSString *screen_name;
 

@end
