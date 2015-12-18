//
//  WBTabBarController.h
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBTabBarController : UITabBarController
- (void)addOneChildVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;
@end
