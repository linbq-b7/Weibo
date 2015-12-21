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
 *  @param imageName            <#imageName description#>
 *  @param highlightedImageName <#highlightedImageName description#>
 *  @param target               <#target description#>
 *  @param action               <#action description#>
 *
 *  @return <#return value description#>
 */
+ (UIBarButtonItem *)initWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

@end
