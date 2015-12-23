//
//  UIView+Extension.h
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
/**
 *  UIView的X轴坐标
 */
@property (nonatomic, assign) CGFloat x;
/**
 *  UIView的Y轴坐标
 */
@property (nonatomic, assign) CGFloat y;
/**
 *  UIView的中心点X轴坐标
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 *  UIView的中心的Y轴坐标
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 *  UIView的宽度
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  UIView的高度
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  UIView的frame尺寸
 */
@property (nonatomic, assign) CGSize size;
/**
 *  UIView的origin
 */
@property (nonatomic, assign) CGPoint origin;
@end
