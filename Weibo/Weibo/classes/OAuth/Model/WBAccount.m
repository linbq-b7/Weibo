//
//  WBAccount.m
//  Weibo
//
//  Created by lbq on 16/1/5.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import "WBAccount.h"

@implementation WBAccount

/**
 *  当一个对象要归档进沙盒时,调用此方法
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    // 获取账号存储的时间
    self.created_time = [NSDate date];
    
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.created_time forKey:@"created_time"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.screen_name forKey:@"screen_name"];
}

/**
 *  当一个对象要从沙盒解档时,调用此方法
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.created_time = [decoder decodeObjectForKey:@"created_time"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.screen_name = [decoder decodeObjectForKey:@"screen_name"];
    } 
    return self;
}

@end
