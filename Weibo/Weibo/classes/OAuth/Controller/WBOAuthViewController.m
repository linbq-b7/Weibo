//
//  WBOAuthViewController.m
//  Weibo
//
//  Created by lbq on 15/12/25.
//  Copyright © 2015年 linbq-b7. All rights reserved.
//

#import "WBOAuthViewController.h"
#import "WBTabBarController.h"
#import "WBNewFeatureViewController.h"
#import "WBAccountTool.h"
#import "MBProgressHUD+MJ.h"

#import <AFNetworking.h>
#import <MJExtension.h>

@interface WBOAuthViewController () <UIWebViewDelegate>

@end
@implementation WBOAuthViewController

/**
 *  https://api.weibo.com/oauth2/authorize?client_id=325558412&redirect_uri=http://
 *
 *  client_id      true	string	申请应用时分配的AppKey。
 *  redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
 *  scope          false	string	申请scope权限所需参数，可一次申请多个scope权限，用逗号分隔。使用文档
 *  state          false	string	用于保持请求和回调的状态，在回调时，会在Query Parameter中回传该参数。开发者可以用这个参数验证请求有效性，也可以记录用户请求授权页前的位置。这个参数可用于防止跨站请求伪造（CSRF）攻击
 *  display        false	string	授权页面的终端类型，取值见下面的说明。
 *  forcelogin     false	boolean	是否强制用户重新登录，true：是，false：否。默认false。
 *  language       false	string	授权页语言，缺省为中文简体版，en为英文版。英文版测试中，开发者任何意见可反馈至 @微博 API
 *  App Key：325558412
 *  App Secret：0b979cd7af2572def6ab510a54f00c20
 */

- (void)viewDidLoad
{
    // 1.创建webview
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    // 2.用webview加载新浪登陆页面
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=325558412&redirect_uri=http://"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

/**
 *  webview开始加载
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中..."];
    
}


/**
 *  webview加载完成
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

/**
 *  webview加载失败
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.获得url http://localhost/?code=db2d9d17a243a204003362377c755ece
    NSString *url = request.URL.absoluteString;

    // 2.判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        // 截取code=后的access_token
        int fromIndex = (int)(range.location + range.length);
        NSString * code = [url substringFromIndex:fromIndex];
        
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
        
        // 禁止加载回调地址
        return NO;
        
    }
    return YES;
}

/**
 *  利用code换取一个accessToken
 *  https://api.weibo.com/oauth2/access_token
 *  client_id       true	string	申请应用时分配的AppKey。
 *  client_secret	true	string	申请应用时分配的AppSecret。
 *  grant_type      true	string	请求的类型，填写authorization_code
 *
 *  grant_type为authorization_code时
 *  code            true	string	调用authorize获得的code值。
 *  redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
 *
 *  App Key：325558412
 *  App Secret：0b979cd7af2572def6ab510a54f00c20
 *
 *  {
        "access_token" = "2.00DiMxBG0IcAC36719606d81XTC4_C";
        "expires_in" = 179207;
        "remind_in" = 179207;
        uid = 5525683539;
     }
 *  @param code code
 */
- (void)accessTokenWithCode:(NSString *)code
{
    // 1.AFN请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 设置接收类型为新浪返回类型text/plain
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"325558412";
    params[@"client_secret"] = @"0b979cd7af2572def6ab510a54f00c20";
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = @"http://";
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary * _Nonnull responseObject) {
        
        [MBProgressHUD hideHUD];
        
        // 将返回的数据存入沙盒中,放在Document中
        WBAccount *account = [WBAccount mj_objectWithKeyValues:responseObject];
        // 存储账号信息
        [WBAccountTool saveAccount:account];
        
        // 版本号判断,控制是否显示新特
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        WBLog(@"请求失败...%@",error);
    }];
    
}



@end
