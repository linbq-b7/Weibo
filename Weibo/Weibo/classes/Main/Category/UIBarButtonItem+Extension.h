//
//  UIBarButtonItem+Extension.h
//  Weibo
//
//  Created by lbq on 15/12/21.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/**
 *  初始化按钮
 *
 *  @param imageName            图片名称
 *  @param highlightedImageName 高亮图片名称
 *  @param target               监听事件的对象
 *  @param action               事件
 *
 *  @return 创建好的按钮
 */
+ (UIBarButtonItem *)initWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

@end
