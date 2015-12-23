//
//  WBTabBarController.h
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBTabBarController : UITabBarController
/**
 *  添加一个子控制器
 *
 *  @param childVC           添加的子控制器对象
 *  @param title             子控制器对象的名称
 *  @param imageName         子控制器对象显示的图片名称
 *  @param selectedImageName 子控制器对象选中时显示的图片名称
 */
- (void)addOneChildVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;
@end
