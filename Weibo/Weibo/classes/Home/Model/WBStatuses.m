//
//  WBStatuse.m
//  Weibo
//
//  Created by lbq on 16/1/5.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import "WBStatuses.h"
#import "WBStatusesPhoto.h"

#import <MJExtension.h>

@implementation WBStatuses

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"pic_urls" : [WBStatusesPhoto class]};
}

@end
