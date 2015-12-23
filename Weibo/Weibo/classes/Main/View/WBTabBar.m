//
//  WBTabBar.m
//  Weibo
//
//  Created by lbq on 15/12/23.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBTabBar.h"

@interface WBTabBar ()

/**
 *  加号按钮对象
 */
@property (nonatomic , weak)  UIButton *plusBtn;

@end

@implementation WBTabBar
/**
 Auto property synthesis will not synthesize property 'delegate'; it will be implemented by its superclass, use @dynamic to acknowledge intention
 
 这是说编译器自动给属性delegate合成getter和setter的时候将会在它的父类上实现,也就是说坑爹的xcode6.3升级后ios8.3版本的UIViewController里有一个title属性,现在它不知道到底是哪一个title.
 
 这不是我们想要的,所以添加 @dynamic告诉编译器这个属性是动态的,动态的意思是等你编译的时候就知道了它只在本类合成;
 在@implementation中添加@dynamic delegate; .h文件中就不会出现警告 强迫症患者注意.
 */
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加中间的加号按钮到tabbar中
        UIButton *plusBtn = [[UIButton alloc]init];
        // 设置图片与背景图片
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        // 按钮的大小等于按钮当前背景图片的大小
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        // 按钮添加点击事件
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
    
    // 设置TabBar的按钮样式
    [self setTabBarButtonStyle];
    
}

/**
 *  设置TabBar的按钮样式
 */
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
