//
//  AppDelegate.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "AppDelegate.h"
#import "WBTabBarController.h"
#import "WBNewFeatureViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 2.设置窗口根控制器
    // 版本号判断,显示新特性
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
        self.window.rootViewController = tabbarVC;
    }else {
        // 版本号不同
        // 4.将最新的版本号存入沙盒中
        [[NSUserDefaults standardUserDefaults] setObject:currVersion forKey:key];
        // 即刻通报沙盒数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 显示新特性
        WBNewFeatureViewController *newFeatureVC = [[WBNewFeatureViewController alloc]init];
        self.window.rootViewController = newFeatureVC;
    }

    // 3.显示窗口(成为主窗口)
    [self.window makeKeyAndVisible];

    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
