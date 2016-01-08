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
#import "WBStatusesCell.h"
#import "WBStatusesFrame.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface WBHomeTableViewController () <WBDropDownMenuDelegate>
/** 存放微博数据可变数组 */
@property (nonatomic ,strong) NSMutableArray<WBStatusesFrame *> *statusesFrameArray;
@end

@implementation WBHomeTableViewController

/**
 *  懒加载
 *
 *  @return statusesFrameArray实例
 */
- (NSMutableArray *)statusesFrameArray
{
    if (!_statusesFrameArray) {
        self.statusesFrameArray = [NSMutableArray array];
    }
    return _statusesFrameArray;
    
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
    
    // 定时器显示多少条未读数据
    [self setUpRunLoopTimer];
}

/**
 *  定时器
 */
- (void)setUpRunLoopTimer
{
    // 每60秒向服务器请求一次未读消息
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setUpUnReadCount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  显示多少条未读数据
 *  获取某个用户的各种消息未读数
 *  https://rm.api.weibo.com/2/remind/unread_count.json
 *  source          false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 *  access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 *  uid             true	int64	需要获取消息未读数的用户UID，必须是当前登录用户。
 *  callback        false	string	JSONP回调函数，用于前端调用返回JS格式的信息。
 *  unread_message	false	boolean	未读数版本。0：原版未读数，1：新版未读数。默认为0。
 */
- (void)setUpUnReadCount
{
    // 请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    // 发起请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
        // 微博未读数
        NSString *unReadCount = [responseObject[@"status"] description];
        // 设置未读消息数量
        [self setUnReadCount:unReadCount];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"请求失败...%@",error);
    }];
}

/**
 *  设置未读消息数量
 *
 *  @param unReadCount 未读消息数量
 */
- (void)setUnReadCount:(NSString *)unReadCount
{
    if (IOS8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    WBLog(@"你有%d条新的消息,请注意查收",unReadCount.intValue);
    
    if ([unReadCount isEqualToString:@"0"]) {
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    } else {
        self.tabBarItem.badgeValue = unReadCount;
        [UIApplication sharedApplication].applicationIconBadgeNumber = [unReadCount intValue];
    }
}

/**
 *  加载微博信息后设置剩余未读消息数量
 */
- (void)readAndSetUnReadCount:(unsigned long)readCount
{
    NSString *unReadCount = self.tabBarItem.badgeValue;
    if (unReadCount) {
        // 有未读消息数
        unsigned long count = unReadCount.intValue - readCount;
        if (count > 0) {
            // 未读消息数量大于0
            [self setUnReadCount:[NSString stringWithFormat:@"%lu",count]];
        } else if (count <= 0) {
            // 未读消息数量小于等于0
            [self setUnReadCount:@"0"];
        }
    }
}


/**
 *  加载上次保存的微博数据
 */
- (void)setUpLastStatuses
{
    // 获取上次存放沙盒中的微博数据
    NSArray *lastArray = [WBStatusesTool loadStatuses];
    
    // 将微博模型数组 转为 微博Frame模型数组
    NSArray *statusesFrameArray = [self statusesArrayToStatusesFrameArray:lastArray];
    
    // 将上次沙盒中保存的微博数据显示出来
    [self.statusesFrameArray addObjectsFromArray:statusesFrameArray];
}

/**
 *  将最新的20条微博存入沙盒
 */
- (void)savestatusesInMachine
{
    // 将微博Frame模型数组 转为 微博模型数组
    NSArray *statusesArray = [self statusesFrameArrayToStatusesArray:self.statusesFrameArray];
    
    // 将微博数据保存到沙盒中
    [WBStatusesTool saveStatuses:statusesArray];
}

/**
 *  将微博模型数组 转为 微博Frame模型数组
 *
 *  @param statusesArray 微博模型数组
 *
 *  @return 微博Frame模型数组
 */
- (NSArray *)statusesArrayToStatusesFrameArray:(NSArray *)statusesArray
{
    NSMutableArray *statusesFrameArray = [NSMutableArray array];
    for (WBStatuses *statuses in statusesArray) {
        WBStatusesFrame *statusesFrame = [[WBStatusesFrame alloc]init];
        statusesFrame.statuses = statuses;
        [statusesFrameArray addObject:statusesFrame];
    }
    return statusesFrameArray;
}

/**
 *  将微博Frame模型数组 转为 微博模型数组
 *
 *  @param statusesFrameArray 微博Frame模型数组
 *
 *  @return 微博模型数组
 */
- (NSArray *)statusesFrameArrayToStatusesArray:(NSArray *)statusesFrameArray
{
    NSMutableArray *statusesArray = [NSMutableArray array];
    for (WBStatusesFrame *statusesFrame in statusesFrameArray) {
        WBStatuses *statuses = [[WBStatuses alloc]init];
        statuses = statusesFrame.statuses;
        [statusesArray addObject:statuses];
    }
    return statusesArray;
}


/**
 *  集成上拉/下拉刷新(基于MJRefresh)
 */
- (void)setUpMoreStatuses
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatuses)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatuses)];
    
    // 集成下拉刷新控件(ios自带)
    //[self setUpDownRefresh];
    
    // 集成上拉刷新控件(自定义)
    //[self setUpUpRefresh];
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
    WBStatuses *lastStatuses = [self.statusesFrameArray lastObject].statuses;
    long long maxId = lastStatuses.idstr.longLongValue - 1;
    params[@"max_id"] = @(maxId);
    // 发起请求
    [mgr GET:@"https://api.weibo.com/2/statuses/public_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
        // json转为模型
        NSArray *moreStatuses = [WBStatuses mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将微博模型数组 转为 微博Frame模型数组
        NSArray *statusesFrameArray = [self statusesArrayToStatusesFrameArray:moreStatuses];
        
        // 将最新的微博数据加到数组最后
        [self.statusesFrameArray addObjectsFromArray:statusesFrameArray];
        
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
    WBStatuses *firstStatuses = [self.statusesFrameArray firstObject].statuses;
    long long since_id = firstStatuses.idstr.longLongValue;
    params[@"since_id"] = @(since_id);
    // 发起请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
        // json转为模型
        NSArray *newStatuses = [WBStatuses mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将微博模型数组 转为 微博Frame模型数组
        NSArray *statusesFrameArray = [self statusesArrayToStatusesFrameArray:newStatuses];
        
        // 将最新的微博数据加到数组最前面
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusesFrameArray insertObjects:statusesFrameArray atIndexes:indexSet];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 隐藏当前的上拉刷新控件
        [self.tableView.mj_header endRefreshing];
        
        // 保存最新的微博数据到沙盒中
        [self savestatusesInMachine];
        
        // 显示下拉刷新更新了多少条数据
        [self showNewStatusesCount:newStatuses.count];
        
        // 下拉刷新数据后设置剩余未读消息数量
        [self readAndSetUnReadCount:newStatuses.count];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"请求失败...%@",error);
        // 隐藏当前的上拉刷新控件
        [self.tableView.mj_header endRefreshing];
        
    }];
}

/**
 *  显示下拉刷新更新了多少条数据
 */
- (void)showNewStatusesCount:(unsigned long)count
{
    // 1.创建label
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    countLabel.text = [NSString stringWithFormat:@" %lu 条新微博",count];
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
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
        // json转为模型
        NSArray *newStatuses = [WBStatuses mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];

        // 将微博模型数组 转为 微博Frame模型数组
        NSArray *statusesFrameArray = [self statusesArrayToStatusesFrameArray:newStatuses];
        
        // 最新的微博数据20条
        [self.statusesFrameArray removeAllObjects];
        [self.statusesFrameArray addObjectsFromArray:statusesFrameArray];
        
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
 *  https://api.weibo.com/2/statuses/friends_timeline.json
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
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
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
    return self.statusesFrameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建自定义cell
    WBStatusesCell *cell = [WBStatusesCell cellWithtableView:tableView];
    
    // 将微博FRAME模型传给cell
    cell.statusesFrame = self.statusesFrameArray[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIViewController *tableVC = [[UIViewController alloc]init];
//    tableVC.view.backgroundColor = WBRandomColor;
//    [self.navigationController pushViewController:tableVC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.statusesFrameArray[indexPath.row].cellHeight;
}

#pragma mark - WBDropDownMenuDelegate代理方法
/**
 *  代理方法,当下拉弹出面板消失时,改版titlebtn图标显示(向上/向下)
 */
- (void)dropDownMenudismiss:(WBDropDownMenu *)menu
{
    ((UIButton *)self.navigationItem.titleView).selected = NO;
}

- (void)dropDownMenudisshow:(WBDropDownMenu *)menu
{
    ((UIButton *)self.navigationItem.titleView).selected = YES;
}

@end
