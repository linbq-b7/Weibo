//
//  WBUser.m
//  Weibo
//
//  Created by lbq on 16/1/5.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import "WBUser.h"
#import <MJExtension.h>

@implementation WBUser
/**
 *  将属性名换为其他key去字典中取值
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"descriptionstr" : @"description" };
}

@end
