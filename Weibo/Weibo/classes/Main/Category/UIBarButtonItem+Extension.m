//
//  UIBarButtonItem+Extension.m
//  Weibo
//
//  Created by lbq on 15/12/21.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)initWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action
{
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithName:highlightedImageName] forState:UIControlStateHighlighted];
    // 设置按钮尺寸为背景图片尺寸
    btn.size = btn.currentBackgroundImage.size;
    // btn按钮监听事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

@end
