//
//  UIImage+Extension.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

/**
 *  图片兼容ios6.0与更高版本
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage * image = nil;
    if (IOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    
    return image;
}

@end
