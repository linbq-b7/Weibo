//
//  WBNewFeatureViewController.m
//  Weibo
//
//  Created by lbq on 15/12/23.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBNewFeatureViewController.h"
#import "WBTabBarController.h"

#define WBNewFeatureCount 4

@interface WBNewFeatureViewController () <UIScrollViewDelegate>
@property (nonatomic , weak)  UIPageControl *pageControl;
@end

@implementation WBNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i < WBNewFeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.x = scrollW * i;
        imageView.y = 0;
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d",i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        if (i == WBNewFeatureCount - 1) {
            // 最后一张图片 添加开始微博按钮
            [self setShareBtnAndStartBtn:imageView];
        }
    }
    
    // scrollView垂直方向不滚动,Y设为0
    scrollView.contentSize = CGSizeMake(scrollW * WBNewFeatureCount, 0);
    // scrollView去除弹簧效果
    scrollView.bounces = NO;
    // scrollView分页效果
    scrollView.pagingEnabled = YES;
    // scrollView去除水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // 3.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = WBNewFeatureCount;
    pageControl.currentPageIndicatorTintColor = WBColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = WBColor(189, 189, 189);
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 50;
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
}

/**
 *  设置最后一个图片上的分享微博和开始微博按钮
 */
- (void)setShareBtnAndStartBtn:(UIImageView *)imageView
{
    // 分享给大家 (checkbox)
    UIButton *shareBtn = [[UIButton alloc]init];
    shareBtn.width = 130;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width  * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.imageEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, 15);
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 开启用户交互
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:shareBtn];
    
    // 开始微博
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.centerX;
    startBtn.centerY = shareBtn.centerY + 40;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];

}

/**
 *  分享checkbox点击事件
 */
- (void)shareBtnClick:(UIButton *)shareBtn
{
    shareBtn.selected = !shareBtn.isSelected;
}

/**
 *  开始微博按钮点击事件
 */
- (void)startBtnClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[WBTabBarController alloc]init];

}

/**
 *  滚动条视图滚动监听方法
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
    
}

@end
