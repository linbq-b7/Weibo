//
//  WBDropDownView.h
//  Weibo
//
//  Created by lbq on 15/12/22.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBDropDownMenu;

@protocol WBDropDownMenuDelegate <NSObject>
@optional
/**
 *  下拉菜单消失 代理方法
 *
 *  @param menu self
 */
- (void)dropDownMenudismiss:(WBDropDownMenu *)menu;
/**
 *  下拉菜单显示 代理方法
 *
 *  @param menu self
 */
- (void)dropDownMenudisshow:(WBDropDownMenu *)menu;
@end

@interface WBDropDownMenu : UIView

@property (nonatomic , weak)  id<WBDropDownMenuDelegate> delegate;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;

/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;

/**
 *  创建下拉菜单
 */
+ (instancetype)createMenu;

/**
 *  显示下拉菜单
 */
- (void)showMenuFromView:(UIView *)fromView;
/**
 *  下拉菜单销毁
 */
- (void)dismiss;
@end
