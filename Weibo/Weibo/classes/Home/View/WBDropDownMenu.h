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
- (void)dropDownMenudismiss:(WBDropDownMenu *)menu;
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
 *  销毁
 */
- (void)dismiss;
@end
