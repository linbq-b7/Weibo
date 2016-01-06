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
#import "WBStatusesTool.h"
#import "WBLoadMoreFooter.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface WBHomeTableViewController () <WBDropDownMenuDelegate>
/** 存放微博数据可变数组 */
@property (nonatomic ,strong) NSMutableArray *statuses;
@end

@implementation WBHomeTableViewController

/**
 *  懒加载
 *
 *  @return statuses实例
 */
- (NSMutableArray *)statuses
{
    if (!_statuses) {
        self.statuses = [NSMutableArray array];
    }
    return _statuses;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏信息
    [self setUpNavigation];
    
    // 设置用户昵称
    [self setUpUserInfo];
    
    // 加载上次保存的微博数据
    [self setUpLastStatuses];
    
    // 加载最新微博数据
    [self setUpNewStatuses];
    
    // 集成上拉/下拉刷新(基于MJRefresh)
    [self setUpMoreStatuses];
    
    // 集成下拉刷新控件(ios自带)
    //[self setUpDownRefresh];
    
    // 集成上拉刷新控件(自定义)
    //[self setUpUpRefresh];
    
    
}

/**
 *  加载上次保存的微博数据
 */
- (void)setUpLastStatuses
{
    NSArray *lastArray = [WBStatusesTool loadStatuses];
    // 将上次沙盒中保存的微博数据显示出来
    [self.statuses addObjectsFromArray:lastArray];
}

/**
 *  将最新的20条微博存入沙盒
 */
- (void)savestatusesInMachine
{
    [WBStatusesTool saveStatuses:self.statuses];
}

/**
 *  集成上拉/下拉刷新(基于MJRefresh)
 */
- (void)setUpMoreStatuses
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatuses)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatuses)];
    
}

/**
 *  集成上拉刷新控件(自定义)
 */
- (void)setUpUpRefresh
{
    self.tableView.tableFooterView = [WBLoadMoreFooter footer];
    self.tableView.tableFooterView.hidden = YES;
}

/**
 *  集成下拉刷新控件(ios自带)
 */
- (void)setUpDownRefresh
{
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(downRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
}

/**
 *  下拉刷新控件监听事件,加载最新的微博数据
 */
- (void)downRefresh:(UIRefreshControl *)refresh
{
    // 加载最新的微博数据
    [self loadNewStatuses];
    
    // 隐藏正在加载中状态
    [refresh endRefreshing];
}

/**
 *  上拉刷新 加载最新的微博数据 (获取当前登录用户及其所关注（授权）用户的最新微博)
 *  https://api.weibo.com/2/statuses/friends_timeline.json
 *  source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 *  access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 *  since_id        false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
 *  max_id          false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
 *  count           false	int     单页返回的记录条数，最大不超过100，默认为20。
 *  page            false	int     返回结果的页码，默认为1。
 *  base_app        false	int     是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 *  feature         false	int     过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
 *  trim_user       false	int     返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
 */
- (void)loadMoreStatuses
{
    // 请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    WBStatuses *lastStatuses = [self.statuses lastObject];
    long long maxId = lastStatuses.idstr.longLongValue - 1;
    params[@"max_id"] = @(maxId);
    // 发起请求
    [mgr GET:@"https://api.weibo.com/2/statuses/public_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
        // json转为模型
        NSArray *moreStatuses = [WBStatuses mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将最新的微博数据加到数组最后
        [self.statuses addObjectsFromArray:moreStatuses];
        
        // 刷新表格
        [self.tableView reloadData];
        // 隐藏当前的上拉刷新控件
        [self.tableView.mj_footer endRefreshing];
        WBLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"请求失败...%@",error);
        // 隐藏当前的上拉刷新控件
        [self.tableView.mj_footer endRefreshing];
        
    }];
}


/**
 *  下拉刷新 加载最新的微博数据 (获取当前登录用户及其所关注（授权）用户的最新微博)
 *  https://api.weibo.com/2/statuses/friends_timeline.json
 *  source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 *  access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 *  since_id        false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
 *  max_id          false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
 *  count           false	int     单页返回的记录条数，最大不超过100，默认为20。
 *  page            false	int     返回结果的页码，默认为1。
 *  base_app        false	int     是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 *  feature         false	int     过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
 *  trim_user       false	int     返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
 */
- (void)loadNewStatuses
{
    // 请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    WBStatuses *firstStatuses = [self.statuses firstObject];
    long long since_id = firstStatuses.idstr.longLongValue - 1;
    params[@"since_id"] = @(since_id);
    // 发起请求
    [mgr GET:@"https://api.weibo.com/2/statuses/public_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
        // json转为模型
        NSArray *newStatuses = [WBStatuses mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将最新的微博数据加到数组最前面
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statuses insertObjects:newStatuses atIndexes:indexSet];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 隐藏当前的上拉刷新控件
        [self.tableView.mj_header endRefreshing];
        
        // 保存最新的微博数据到沙盒中
        [self savestatusesInMachine];
        
        // 显示下拉刷新更新了多少条数据
        [self showNewStatusesCount:newStatuses.count];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"请求失败...%@",error);
        // 隐藏当前的上拉刷新控件
        [self.tableView.mj_header endRefreshing];
        
    }];
}

/**
 *  显示下拉刷新更新了多少条数据
 */
- (void)showNewStatusesCount:(int)count
{
    // 1.创建label
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    countLabel.text = [NSString stringWithFormat:@" %d 条新微博",count];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = [UIColor whiteColor];
    
    // 2.设置其他属性
    countLabel.width = [UIScreen mainScreen].bounds.size.width;
    countLabel.height = 35;
    // 横批状态下,navigationBar上没有时间栏,高度不能加入计算,这里通过算出navigationBar的底部Y值 减去 countLabel的高度
    countLabel.y = (CGRectGetMaxY(self.navigationController.navigationBar.frame)) - countLabel.height;
    
    
    // 3.添加到导航控制器背后
    [self.navigationController.view insertSubview:countLabel belowSubview:self.navigationController.navigationBar];
    
    // 4.创建进入退出动画
    NSTimeInterval time = 1.0;
    [UIView animateWithDuration:(time) animations:^{
        // 1秒内匀速滑入
        //countLabel.y += countLabel.height;
        countLabel.transform = CGAffineTransformMakeTranslation(0, countLabel.height);
        // 匀速滑入同时播放声效
        AudioServicesPlaySystemSound(1000);
        
    } completion:^(BOOL finished) {
        NSTimeInterval delay = 1.0;
        [UIView animateWithDuration:time delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            // 延迟1秒后,1秒内匀速滑出
            //countLabel.y -= countLabel.height;
            countLabel.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 动画完成后,从负控件移除
            [countLabel removeFromSuperview];
        }];
    }];
    
    
}

/**
 *  加载最新微博数据 (获取当前登录用户及其所关注（授权）用户的最新微博)
 *  https://api.weibo.com/2/statuses/friends_timeline.json
 *  source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 *  access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 *  since_id        false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
 *  max_id          false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
 *  count           false	int     单页返回的记录条数，最大不超过100，默认为20。
 *  page            false	int     返回结果的页码，默认为1。
 *  base_app        false	int     是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 *  feature         false	int     过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
 *  trim_user       false	int     返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
 */
- (void)setUpNewStatuses
{
    // 请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    // 发起请求
    [mgr GET:@"https://api.weibo.com/2/statuses/public_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
        // json转为模型
        NSArray *newStatuses = [WBStatuses mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 最新的微博数据20条
        [self.statuses removeAllObjects];
        [self.statuses addObjectsFromArray:newStatuses];
        
        // 保存最新的微博数据到沙盒中
        [self savestatusesInMachine];
        
        // 刷新表格
        [self.tableView reloadData];
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
    WBStatuses *statuse = self.statuses[indexPath.row];
    cell.textLabel.text = statuse.text;
    WBUser *user = statuse.user;
    UIImage *avatar_default_small = [UIImage imageNamed:@"avatar_default"];
 
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url]  placeholderImage:avatar_default_small];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *tableVC = [[UIViewController alloc]init];
    tableVC.view.backgroundColor = WBRandomColor;
    [self.navigationController pushViewController:tableVC animated:YES];

}

#pragma mark - WBDropDownMenuDelegate代理方法
/**
 *  代理方法,当下拉弹出面板消失时,改版titlebtn图标显示(向上/向下)
 *
 *  @param menu <#menu description#>
 */
- (void)dropDownMenudismiss:(WBDropDownMenu *)menu
{
    ((UIButton *)self.navigationItem.titleView).selected = NO;
}

- (void)dropDownMenudisshow:(WBDropDownMenu *)menu
{
    ((UIButton *)self.navigationItem.titleView).selected = YES;
}

/**
 *  scrollView 监听滚动条底部上拉刷新事件
 *  并不是很好用,有BUG,暂时这样,后期改为MJRefresh控件刷新
 */
//#warning 监听scrollview滚动条并不是很好用,有BUG,暂时这样,后期改为MJRefresh控件刷新
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    //    scrollView == self.tableView == self.view
//    // 如果tableView还没有数据，就直接返回
//    if (self.statuses.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
////    WBLog(@"scrollView---");
//    CGFloat offsetY = scrollView.contentOffset.y;
//    
//    // 当最后一个cell完全显示在眼前时，contentOffset的y值
//    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
//    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
//        // 显示footer
//        self.tableView.tableFooterView.hidden = NO;
//        
//        // 加载更多的微博数据
//        [self loadMoreStatuses];
//        WBLog(@"加载更多的微博数据");
//    }
//    
//    /*
//     contentInset：除具体内容以外的边框尺寸
//     contentSize: 里面的具体内容（header、cell、footer），除掉contentInset以外的尺寸
//     contentOffset:
//     1.它可以用来判断scrollView滚动到什么位置
//     2.指scrollView的内容超出了scrollView顶部的距离（除掉contentInset以外的尺寸）
//     */
//    
//    
//}



@end
