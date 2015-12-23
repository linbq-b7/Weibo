//
//  WBTabBarController.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBTabBarController.h"
#import "WBHomeTableViewController.h"
#import "WBMessageTableViewController.h"
#import "WBComposeTableViewController.h"
#import "WBDiscoverTableViewController.h"
#import "WBProfileTableViewController.h"
#import "WBNavigationController.h"
#import "WBTabBar.h"
@interface WBTabBarController () <WBTabBarDelegate>

@end

@implementation WBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    WBHomeTableViewController *home = [[WBHomeTableViewController alloc]init];
    [self addOneChildVC:home title:@"首页" imageName:@"tabbar_home"  selectedImageName:@"tabbar_home_selected"];
 
    WBMessageTableViewController *message = [[WBMessageTableViewController alloc]init];
    [self addOneChildVC:message title:@"消息" imageName:@"tabbar_message_center"  selectedImageName:@"tabbar_message_center_selected"];
    
    WBDiscoverTableViewController *discover = [[WBDiscoverTableViewController alloc]init];
    [self addOneChildVC:discover title:@"发现" imageName:@"tabbar_discover"  selectedImageName:@"tabbar_discover_selected"];
    
    WBProfileTableViewController *profile = [[WBProfileTableViewController alloc]init];
    [self addOneChildVC:profile title:@"我" imageName:@"tabbar_profile"  selectedImageName:@"tabbar_profile_selected"];
    
    // 替换系统tabbar为自定义WBTabBar 
    [self setValue:[[WBTabBar alloc]init] forKeyPath:@"tabBar"];
    
}

/**
 *  添加一个子控制器
 *
 *  @param childVC           childVC description
 *  @param title             title description
 *  @param imageName         imageName description
 *  @param selectedImageName selectedImageName description
 */
- (void)addOneChildVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
//    childVC.view.backgroundColor = WBRandomColor;
    // 设置标题
    childVC.title = title;
    // 设置默认图片
    childVC.tabBarItem.image = [UIImage imageWithName:imageName];
    // 设置选择图片
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (IOS7) {
        // 声明图片不使用渲染
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVC.tabBarItem.selectedImage = selectedImage;
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSMutableDictionary *textAttrsSelected= [NSMutableDictionary dictionary];
    textAttrsSelected[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:textAttrsSelected forState:UIControlStateSelected];
    
    // 添加导航控制器
    WBNavigationController *nav = [[WBNavigationController alloc]initWithRootViewController:childVC];
    // 添加到控制器
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - WBTabBarDelegate 代理方法
- (void)tabBarDidClickPlusBtn:(WBTabBar *)tabbar
{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor redColor];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
