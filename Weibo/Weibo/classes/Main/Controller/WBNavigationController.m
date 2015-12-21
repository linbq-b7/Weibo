//
//  WBNavigationController.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBNavigationController.h"

@implementation WBNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 非栈底控制器时,隐藏底部导航条
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 要再继承前设置隐藏底部导航栏,因为super后就往栈中放入了一个子控制器
    [super pushViewController:viewController animated:animated];

}

@end
