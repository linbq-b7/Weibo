//
//  WBTabBarController.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBTabBarController.h"
@interface WBTabBarController ()

@end

@implementation WBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    UITableViewController *home = [[UITableViewController alloc]init];
    [self addOneChildVC:home title:@"首页" imageName:@"tabbar_home"  selectedImageName:@"tabbar_home_selected"];
 
    UITableViewController *message = [[UITableViewController alloc]init];
    [self addOneChildVC:message title:@"消息" imageName:@"tabbar_message_center"  selectedImageName:@"tabbar_message_center_selected"];
    
    UITableViewController *discover = [[UITableViewController alloc]init];
    [self addOneChildVC:discover title:@"发现" imageName:@"tabbar_discover"  selectedImageName:@"tabbar_discover_selected"];
    
    UITableViewController *profile = [[UITableViewController alloc]init];
    [self addOneChildVC:profile title:@"我" imageName:@"tabbar_profile"  selectedImageName:@"tabbar_profile_selected"];

}


/**
 *  添加一个子控制器
 *
 *  @param childVC           <#childVC description#>
 *  @param title             <#title description#>
 *  @param imageName         <#imageName description#>
 *  @param selectedImageName <#selectedImageName description#>
 */
- (void)addOneChildVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
//    childVC.view.backgroundColor = WBRandomColor;
    // 设置标题
    childVC.tabBarItem.title = title;
    // 设置默认图片
    childVC.tabBarItem.image = [UIImage imageWithName:imageName];
    // 设置选择图片
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (IOS7) {
        // 不要使用系统自带的图片渲染
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVC.tabBarItem.selectedImage = selectedImage;
    // 添加到控制器
    [self addChildViewController:childVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
