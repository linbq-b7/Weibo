//
//  UIWindow+Extension.m
//  Weibo
//
//  Created by lbq on 16/1/5.
//  Copyright © 2016年 linbq-b7. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "WBTabBarController.h"
#import "WBNewFeatureViewController.h"

@implementation UIWindow (Extension)

/**
 *  版本号判断,控制是否显示新特性
 */
- (void)switchRootViewController
{
    // 1.读取沙盒中的版本号
    NSString *key = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 2.读取info.plist中的版本号
    NSString *currVersion = [NSBundle mainBundle].infoDictionary[key];
    // 3.比较沙盒中的版本号与info.plist的版本号
    if ([lastVersion isEqualToString:currVersion]) {
        // 版本号相同
        // 直接进入首页
        WBTabBarController *tabbarVC = [[WBTabBarController alloc]init];
        self.rootViewController = tabbarVC;
    }else {
        // 版本号不同
        // 4.将最新的版本号存入沙盒中
        [[NSUserDefaults standardUserDefaults] setObject:currVersion forKey:key];
        // 即刻通报沙盒数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 显示新特性
        WBNewFeatureViewController *newFeatureVC = [[WBNewFeatureViewController alloc]init];
       self.rootViewController = newFeatureVC;
    }
}

@end
