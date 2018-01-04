//
//  UIWebJSViewController.m
//  OriginalAndJS
//
//  Created by LHWen on 2018/1/3.
//  Copyright © 2018年 LHWen. All rights reserved.
//

#import "UIWebJSViewController.h"
#import "UIWebJS_Plugin.h"   // UIWebView 插件

@interface UIWebJSViewController ()<UIWebPluginDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation UIWebJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"正在加载...";
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TestUIWebViewJS" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 获取js的内容
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    // 通过点击事件的 标识 得到点击方法
    UIWebJS_Plugin *plugin = [UIWebJS_Plugin new];
    plugin.delegate = self;
    context[@"UIWebJS_Plugin"] = plugin;
}

#pragma mark -- UIWebPluginDelegate

- (void)webReturninfo:(NSString *)info {
    
    NSLog(@"---%@----", info);
    
    if ([info isEqualToString:@"返回"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else {  //  使用js 代用原生方法 触发原生调用js方法
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_webView stringByEvaluatingJavaScriptFromString:@"jsfunction()"];
        });
    }
}

- (void)dealloc {
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];  //  清除webView的缓存
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
