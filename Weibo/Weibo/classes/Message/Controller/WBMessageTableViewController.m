//
//  WBMessageTableViewController.m
//  Weibo
//
//  Created by lbq on 15/12/18.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBMessageTableViewController.h"
#import "WBSearchBar.h"
#import "WBDropDownMenu.h"

@interface WBMessageTableViewController ()

@property (nonatomic, strong) WBSearchBar *searchBar;
@end

@implementation WBMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发现群" style:UIBarButtonItemStylePlain target:self action:@selector(foundGroup)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithImageName:@"navigationbar_icon_newchat" highlightedImageName:@"navigationbar_icon_newchat_highlight" target:self action:@selector(newchat)];
    
    
    WBSearchBar *searchBar = [WBSearchBar searchBar];
    searchBar.width = self.view.width;
    searchBar.height = 30;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)foundGroup
{
    WBLog(@"WBMessageTableViewController foundGroup--------");
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = WBRandomColor;
    vc.title = @"发现群";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)newchat
{
    WBLog(@"WBMessageTableViewController newchat--------");
    
    WBDropDownMenu *titmeMenu = [WBDropDownMenu createMenu];
    titmeMenu.height = 200;
    titmeMenu.width = 200;
    
    titmeMenu.content = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [titmeMenu showMenuFromView:self.searchBar];
    
    
//    UIViewController *vc = [[UIViewController alloc]init];
//    vc.view.backgroundColor = WBRandomColor;
//    vc.title = @"发起聊天";
//    [self.navigationController pushViewController:vc animated:YES];
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"消息测试数据---%ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *tableVC = [[UIViewController alloc]init];
    tableVC.view.backgroundColor = WBRandomColor;
    [self.navigationController pushViewController:tableVC animated:YES];
    
}

@end
