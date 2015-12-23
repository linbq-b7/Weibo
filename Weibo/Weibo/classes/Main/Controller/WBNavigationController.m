//
//  WBNavigationController.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBNavigationController.h"

@implementation WBNavigationController

/**
 *  第一次加载时设置主题
 */
+(void)initialize
{
    [self setUIBarButtonItemAppearance];

}

/**
 *  设置UIBarButtonItem主题
 */
+ (void)setUIBarButtonItemAppearance
{
//    WBLog(@"WBNavigationController 初始化 UIBarButtonItem 主题...");
    // 通过appearance设置主题
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    // 设置默认状态下字体为黑色
    NSMutableDictionary *text = [NSMutableDictionary dictionary];
    text[NSForegroundColorAttributeName] = [UIColor blackColor];
    text[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [appearance setTitleTextAttributes:text forState:UIControlStateNormal];
    
    // 设置高亮状态下字体为橘色
    NSMutableDictionary *highlightedText = [NSMutableDictionary dictionary];
    highlightedText[NSForegroundColorAttributeName] = [UIColor orangeColor];
    highlightedText[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [appearance setTitleTextAttributes:highlightedText forState:UIControlStateHighlighted];
    
    // 设置禁止状态下字体为灰色
    NSMutableDictionary *disabledText = [NSMutableDictionary dictionary];
    disabledText[NSForegroundColorAttributeName] = [UIColor grayColor];
    disabledText[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [appearance setTitleTextAttributes:disabledText forState:UIControlStateDisabled];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    // 非栈底控制器时,隐藏底部导航条
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航栏
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"navigationbar_back" highlightedImageName:@"navigationbar_back_highlighted" target:self action:@selector(back)];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithImageName:@"navigationbar_more" highlightedImageName:@"navigationbar_more_highlighted" target:self action:@selector(more)];

    }
    
    // 要再继承前设置隐藏底部导航栏,因为super后就往栈中放入了一个子控制器
    [super pushViewController:viewController animated:animated];

}

/**
 *  返回
 */
- (void)back
{
    WBLog(@"WBNavigationController back------");
    [self popViewControllerAnimated:YES];

}

/**
 *  更多
 */
- (void)more
{
    WBLog(@"WBNavigationController more------");
    [self popToRootViewControllerAnimated:YES];
    
}

@end
