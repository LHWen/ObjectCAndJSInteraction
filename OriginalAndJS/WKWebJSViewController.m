//
//  WKWebJSViewController.m
//  OriginalAndJS
//
//  Created by LHWen on 2018/1/3.
//  Copyright © 2018年 LHWen. All rights reserved.
//

#import "WKWebJSViewController.h"
#import <WebKit/WebKit.h>
#import "UIWebJSViewController.h"

@interface WKWebJSViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *kWebView;

@end

@implementation WKWebJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"正在加载...";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池，由于没有属性可以设置，也没有方法可以调用，不用手动创建
    config.processPool = [[WKProcessPool alloc] init];
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"js_WKWebView"];
    
    
    _kWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    _kWebView.navigationDelegate = self;
    _kWebView.UIDelegate = self;
    [_kWebView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"TestWKWebViewJS" withExtension:@"html"]]];    // 注意 https
    [self.view addSubview:_kWebView];
}

#pragma mark -- WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载...");
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"内容开始返回...");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"网页加载成功，在此做其他操作");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WKWebView" message:@"网页加载成功，在此做其他操作" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
    self.navigationItem.title = _kWebView.title;
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"页面加载失败...");
}

//------------------------------- 页面跳转的代理有三种 -----------------------
//// 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//
//}
//
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//
//}
//
//// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//}

#pragma mark -- WKUIDelegate

//// 创建一个新的WebView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//
//    WKWebView *newsWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height-300)];
//    newsWKWebView.navigationDelegate = self;
//    newsWKWebView.UIDelegate = self;
//    [newsWKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com"]]];    // 注意 https
//
//    return newsWKWebView;
//}
//
///** 显示一个JS的Alert（与JS交互）
// *  web界面中有弹出警告框时调用
// *  @param webView           实现该代理的webview
// *  @param message           警告框中的内容
// *  @param frame             主窗口
// *  @param completionHandler 警告框消失调用
// */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    NSString *host = webView.URL.host;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:host?:@"来自网页的消息" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
//
///** 显示一个确认框（JS的）
// *  @abstract显示一个JavaScript确认面板。
// *  @param webView web视图调用委托方法。
// *  @param消息显示的消息。
// *  @param帧的信息帧的JavaScript发起这个调用。
// *  @param completionHandler确认后完成处理程序调用面板已经被开除。
// *  是的如果用户选择OK,如果用户选择取消。
// *  @discussion用户安全,您的应用程序应该调用注意这样一个事实一个特定的网站控制面板中的内容。
// * 一个简单的forumla对于识别frame.request.URL.host控制的网站。该小组应该有两个按钮,如可以取消。
// * 如果你不实现这个方法,web视图会像如果用户选择取消按钮。
// */
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
//
//}
//
///** 弹出一个输入框（与JS交互的）
// *  @abstract JavaScript显示一个文本输入面板。
// *  @param webView web视图调用委托方法。
// *  @param消息显示的消息。
// *  @param defaultText初始文本显示在文本输入字段。
// *  @param帧的信息帧的JavaScript发起这个调用。
// *  @param completionHandler后完成处理器调用文本输入面板已被撤职。如果用户选择了通过输入文本好吧,否则零。
// *  @discussion用户安全,您的应用程序应该调用注意这样一个事实一个特定的网站控制面板中的内容。
// *  一个简单的forumla对于识别frame.request.URL.host控制的网站。该小组应该有两个按钮,可以取消,和一个字段等输入文本。
// *  如果你不实现这个方法,web视图会像如果用户选择取消按钮。
// */
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
//
//}
//
//// WebVeiw关闭（9.0中的新方法）
//- (void)webViewDidClose:(WKWebView *)webView {
//
//}

#pragma mark -- WKScriptMessageHandler  从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"%@",message.body);
    
    NSDictionary *dict = message.body;
    
    NSInteger state = [dict[@"state"] integerValue];
    
    if (state == 1) {   // 获取js信息 触发原生方法
//        [[[UIAlertView alloc] initWithTitle:dict[@"title"] message:dict[@"info"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        UIWebJSViewController *vc = [[UIWebJSViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (state == 2) {  // 原生 调用 js 方法
        [_kWebView evaluateJavaScript:@"jsfunction()" completionHandler:nil];
    }
}

- (void)dealloc {
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    //    清除webView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
