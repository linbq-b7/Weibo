//
//  WBTitleButton.m
//  Weibo
//
//  Created by lbq on 15/12/22.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBTitleButton.h"

@implementation WBTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置内部图片居中显示
        self.imageView.contentMode = UIViewContentModeCenter;
        // 设置文字属性右对齐
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        // 设置按钮文字
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = WBNavTitleFont;
        // 设置长按按钮,图片不要变灰
        self.adjustsImageWhenHighlighted = NO;
        // 设置图标
        [self setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage resizedImage:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.x = 0;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
    
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width += 2;
    [super setFrame:frame];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self sizeToFit];
}

@end
