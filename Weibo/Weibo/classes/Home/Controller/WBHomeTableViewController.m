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
#import "WBAccountTool.h"
#import "WBUser.h"
#import "WBStatuse.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>

@interface WBHomeTableViewController () <WBDropDownMenuDelegate>
@property (nonatomic ,strong) NSArray *statuses;
@end

@implementation WBHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏信息
    [self setUpNavigation];
    
    // 设置用户昵称
    [self setUpUserInfo];
    
    // 加载最新微博数据
    [self setUpNewStatuses];
    
}

/**
 *  加载最新微博数据
 *  https://api.weibo.com/2/statuses/public_timeline.json
 *  source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 *  access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 *  count           false	int	单页返回的记录条数，默认为50。
 *  page            false	int	返回结果的页码，默认为1。
 *  base_app        false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 */
- (void)setUpNewStatuses
{
    
    // 请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    // 拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"count"] = @20;
    
    
    // 发起请求
    [mgr GET:@"https://api.weibo.com/2/statuses/public_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
        // json转为模型
       // WBStatuse *statuse = [WBStatuse mj_objectWithKeyValues:responseObject[@"statuses"]];
        self.statuses = responseObject[@"statuses"];
        // 刷新表格
        [self.tableView reloadData];
//        WBLog(@"%@",self.statuses);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"请求失败...%@",error);
        
    }];
    
    
    
}

/**
 *  设置用户昵称
 *  https://api.weibo.com/2/users/show.json
 *
 *  source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 *  access_token    false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 *  uid             false	int64	需要查询的用户ID。
 *  screen_name     false	string	需要查询的用户昵称。
 */
- (void)setUpUserInfo
{
    // 请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
   // mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    // 拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 发起请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
        // json转为模型
        WBUser *user = [WBUser mj_objectWithKeyValues:responseObject];
        NSString *screen_name = user.screen_name;
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        [titleButton setTitle:screen_name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        WBAccount *account = [WBAccountTool account];
        account.screen_name = screen_name;
        [WBAccountTool saveAccount:account];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"请求失败...%@",error);
        
    }];
}

/**
 *  设置导航栏信息
 */
- (void)setUpNavigation
{
    // 导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"navigationbar_friendsearch" highlightedImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendsearch)];
    // 导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithImageName:@"navigationbar_pop" highlightedImageName:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    // 创建文字图片按钮
    WBTitleButton *titleBtn = [[WBTitleButton alloc]init];
    // 设置按钮文字
    // 获取沙盒中的昵称
    WBAccount *account = [WBAccountTool account];
    NSString *screen_name = account.screen_name;
    [titleBtn setTitle:screen_name?screen_name:@"首页" forState:UIControlStateNormal];
    
    // 添加按钮点击事件
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 设置导航的titleView为文字图片按钮
    self.navigationItem.titleView = titleBtn;

    
}

/**
 *  文字图片按钮点击事件
 */
- (void)titleBtnClick:(UIButton *)titleBtn
{

    // 创建下拉菜单
    WBDropDownMenu *menu = [WBDropDownMenu createMenu];
    
    // 创建下拉菜单内容控制器
    WBTitleMenuController *titleMenuVC = [[WBTitleMenuController alloc]init];
    titleMenuVC.view.backgroundColor = [UIColor clearColor];
    titleMenuVC.view.width = 180;
    titleMenuVC.view.height = 44 * 3;
    
    // 放入下拉菜单内容控制
    menu.contentController = titleMenuVC;
    
    // 设置menu代理为self
    menu.delegate = self;
    
    // 显示下拉菜单
    [menu showMenuFromView:titleBtn];  
}

/**
 *  导航栏左边按钮点击事件
 */
- (void)friendsearch
{
    WBLog(@"WBHomeTableViewController friendsearch--------");
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = WBRandomColor;
    vc.title = @"好友关注动态";
    [self.navigationController pushViewController:vc animated:YES];

}

/**
 *  导航栏右边按钮点击事件
 */
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

    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"statuses";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    //cell.textLabel.text = [NSString stringWithFormat:@"首页测试数据---%ld",(long)indexPath.row];
    NSDictionary *dic = self.statuses[indexPath.row];
    cell.textLabel.text = dic[@"text"];
    NSDictionary *user = dic[@"user"];
    UIImage *avatar_default_small = [UIImage imageNamed:@"avatar_default"];
 
    
    [cell.imageView sd_setImageWithURL:user[@"profile_image_url"] placeholderImage:avatar_default_small];
    
    
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
