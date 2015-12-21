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
    
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageH = self.height;
    CGFloat imageW = imageH;
    CGFloat imageX = self.width - imageW;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = self.width - self.height;
    CGFloat titleH = self.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}


@end
