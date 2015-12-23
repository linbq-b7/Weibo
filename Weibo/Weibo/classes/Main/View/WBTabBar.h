//
//  WBTabBar.h
//  Weibo
//
//  Created by lbq on 15/12/23.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBTabBar;

@protocol WBTabBarDelegate <UITabBarDelegate>
@optional
/**
 *  tabBar点击加号按钮代理方法
 *
 *  @param tabbar self
 */
- (void)tabBarDidClickPlusBtn:(WBTabBar *)tabbar;
@end

@interface WBTabBar : UITabBar
@property (nonatomic , weak)  id<WBTabBarDelegate> delegate;
@end
