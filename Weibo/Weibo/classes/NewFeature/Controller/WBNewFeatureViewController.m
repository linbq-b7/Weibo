//
//  WBNewFeatureViewController.m
//  Weibo
//
//  Created by lbq on 15/12/23.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBNewFeatureViewController.h"
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
    
}

@end
