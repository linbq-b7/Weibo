//
//  AppDelegate.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "AppDelegate.h"
#import "WBTabBarController.h"
#import "WBOAuthViewController.h"
#import "WBAccountTool.h"

#import <SDWebImageManager.h>

@interface AppDelegate ()

@end

@implementation NSURLRequest(DataController)
/**
 *  https xcode7 ios9 报错处理
 */
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 从沙盒中读取微博账号信息
    WBAccount *account = [WBAccountTool account];
    
    if (account) {
        [self.window switchRootViewController];
    
    } else {
        // 不存在账号信息
        self.window.rootViewController = [[WBOAuthViewController alloc]init];
    }
    
    
    
    // 3.显示窗口(成为主窗口)
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1.取消下载
    [mgr cancelAll];
    
    // 2.清楚内存中的所有图片
    [mgr.imageCache clearMemory];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 *  当app进入后台时
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
  
    // 向系统申请后台运行资格,但是能维持多久是不确定的
    UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束(过期),就会调用这个block
        [application endBackgroundTask:task];
    }];
    
    // 1.在info.plist 中设置Required background modes 为 App plays audio or streams audio/video using AirPlay(酷狗类型后台播放app)
    // 循环播放0kb的MP3文件,没有声音 伪装后台放歌,提高app的内存优先级别
    
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
