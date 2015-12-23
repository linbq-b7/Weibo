//
//  WBTabBar.m
//  Weibo
//
//  Created by lbq on 15/12/23.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBTabBar.h"

@interface WBTabBar ()

@property (nonatomic , weak)  UIButton *plusBtn;

@end

@implementation WBTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加中间的加号按钮到tabbar中
        
        UIButton *plusBtn = [[UIButton alloc]init];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
        
    }
    return self;
}

/**
 *  加号按钮点击事件
 */
- (void)plusBtnClick
{
    // 通知代理方法 
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusBtn:)]) {
        [self.delegate tabBarDidClickPlusBtn:self];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setTabBarButtonStyle];
    
}

- (void)setTabBarButtonStyle
{
    // 设置加号按钮位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5;
    
    // 设置其他4个按钮位置
    int index = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.width = self.width / 5;
            child.x = child.width * index;
            index++;
            if (index == 2) index++;
        }
    }

}

@end
