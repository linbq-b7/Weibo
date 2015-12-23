//
//  WBHomeTableViewController.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBHomeTableViewController.h"
#import "WBTitleButton.h"
#import "WBDropDownMenu.h"
#import "WBTitleMenuController.h"

@interface WBHomeTableViewController () <WBDropDownMenuDelegate>

@end

@implementation WBHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"navigationbar_friendsearch" highlightedImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendsearch)];
   
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithImageName:@"navigationbar_pop" highlightedImageName:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    
    WBTitleButton *titleBtn = [[WBTitleButton alloc]init];
    // 设置按钮文字
    [titleBtn setTitle:@"首页" forState:UIControlStateNormal];
    
    // 设置图标
    [titleBtn setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    [titleBtn setBackgroundImage:[UIImage resizedImage:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    
    // 设置大小
    titleBtn.width = 100;
    titleBtn.height = 35;
    
    // 添加按钮点击事件
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
}

- (void)titleBtnClick:(UIButton *)titleBtn
{

    // 创建下拉菜单
    WBDropDownMenu *menu = [WBDropDownMenu createMenu];
    
    WBTitleMenuController *titleMenuVC = [[WBTitleMenuController alloc]init];
    titleMenuVC.view.backgroundColor = [UIColor clearColor];
    titleMenuVC.view.width = 180;
    titleMenuVC.view.height = 44 * 3;
    menu.contentController = titleMenuVC;
    
    // 设置menu代理为self
    menu.delegate = self;
    
    // 显示下拉菜单
    [menu showMenuFromView:titleBtn];  
}

- (void)friendsearch
{
    WBLog(@"WBHomeTableViewController friendsearch--------");
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = WBRandomColor;
    vc.title = @"好友关注动态";
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)pop
{
    WBLog(@"WBHomeTableViewController pop--------");
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = WBRandomColor;
    vc.title = @"扫一扫";
    [self.navigationController pushViewController:vc animated:YES];
    
}
     
     
     
     
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"首页测试数据---%ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *tableVC = [[UIViewController alloc]init];
    tableVC.view.backgroundColor = WBRandomColor;
    [self.navigationController pushViewController:tableVC animated:YES];

}

#pragma mark - WBDropDownMenuDelegate代理方法
- (void)dropDownMenudismiss:(WBDropDownMenu *)menu
{
    ((UIButton *)self.navigationItem.titleView).selected = NO;
}

- (void)dropDownMenudisshow:(WBDropDownMenu *)menu
{
    ((UIButton *)self.navigationItem.titleView).selected = YES;
}

@end
