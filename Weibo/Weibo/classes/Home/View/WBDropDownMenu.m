//
//  WBDropDownView.m
//  Weibo
//
//  Created by lbq on 15/12/22.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBDropDownMenu.h"

@interface WBDropDownMenu()

/**
 *  用来显示具体内容的容器
 */
@property (nonatomic, weak) UIImageView *containerView;

/**
 *  目标view
 */
@property (nonatomic , weak) UIView *fromView;

@end

@implementation WBDropDownMenu

/**
 *  懒加载contentVIew
 */
- (UIImageView *)containerView
{
    if (!_containerView) {
        UIImageView *containerView = [[UIImageView alloc]init];
        containerView.image = [UIImage imageWithName:@"popover_background"];
        // 开启交互
        containerView.userInteractionEnabled = YES;
        
        [self addSubview:containerView];
        self.containerView = containerView;
        
    }
    return _containerView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景颜色透明
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setContent:(UIView *)content
{
    _content = content;
    // 调整内容位置
    content.x = 10;
    content.y = 18;
    
    // 设置内容的尺寸 
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;
    self.containerView.height = CGRectGetMaxY(content.frame) + 12;
    
    // 添加内容到内容控件中
    [self.containerView addSubview:content];
    
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    self.content = contentController.view;
}


+ (instancetype)createMenu
{
    
    return [[self alloc]init];
}

-(void)showMenuFromView:(UIView *)fromView
{
    self.fromView = fromView;
    
    // 获取顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加自己到顶层窗口
    [window addSubview:self];
    // 设置尺寸
    self.frame = window.bounds;
    
    // 转行坐标系
    CGRect newFrame = [fromView convertRect:fromView.bounds toView:window];
    
    // 设置位置
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    // 通知代理下拉窗口显示
    if ([self.delegate respondsToSelector:@selector(dropDownMenudisshow:)]) {
        [self.delegate dropDownMenudisshow:self];
    }
}


- (void)dismiss
{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(dropDownMenudismiss:)]) {
        [self.delegate dropDownMenudismiss:self];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
