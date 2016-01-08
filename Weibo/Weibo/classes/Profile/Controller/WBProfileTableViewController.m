//
//  WBProfileTableViewController.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBProfileTableViewController.h"
#import "WBAccountTool.h"
#import "WBOAuthViewController.h"

@interface WBProfileTableViewController ()

@end

@implementation WBProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
    // 导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setUp)];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addFriend
{
    WBLog(@"WBProfileTableViewController addFriend--------");
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = WBRandomColor;
    vc.title = @"添加好友";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)setUp
{
    WBLog(@"WBProfileTableViewController setUp--------");
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = WBRandomColor;
    vc.title = @"设置";
    //[self.navigationController pushViewController:vc animated:YES];
    
    // 退出登录
    // 现在这里实现,后期在做调整,为了真机测试方便
    // 清空沙盒中存放的微博账号信息
    [WBAccountTool LogOut];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[WBOAuthViewController alloc]init];
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"我测试数据---%ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *tableVC = [[UIViewController alloc]init];
    tableVC.view.backgroundColor = WBRandomColor;
    [self.navigationController pushViewController:tableVC animated:YES];
    
}

@end
