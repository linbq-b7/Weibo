//
//  NSString+Extension.m
//  Weibo
//
//  Created by lbq on 16/1/8.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 *  返回文本的尺寸
 *
 *  @param text 文本内容
 *  @param font 文本字体大小
 *
 *  @return 文本尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    return [text sizeWithAttributes:attrs];
}

/**
 *  返回文本的尺寸
 *
 *  @param text 文本内容
 *  @param font 文本字体大小
 *  @param textWidth 文本容器宽度
 *
 *  @return 文本尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font textWidth:(CGFloat)textWidth
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize size = CGSizeMake(textWidth, MAXFLOAT);
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
