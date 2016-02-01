//
//  CBYWebViewController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/23.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "CBYWebViewController.h"
#import "CBYToolbar.h"
#import "Masonry.h"
#import "CBYNavBar.h"
#import "CBYShareController.h"
@interface CBYWebViewController ()<CBYToolbarDelegate, UIWebViewDelegate, CBYNavBarDelegate>
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) CBYToolbar *toolbar;
@property (nonatomic, weak) CBYNavBar *navbar;
@end

@implementation CBYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加WebView
    [self setupWebView];
    //添加下方工具条
    [self setupToolBar];
    //添加导航条
    [self setupNavgationBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

- (void)setupNavgationBar{
    CBYNavBar *navbar = [[CBYNavBar alloc] initWithFrame:self.view.bounds];
    navbar.delegate = self;
    [navbar.button setImage:[UIImage imageNamed:@"Back_White"] forState:UIControlStateNormal];
    [self.view addSubview:navbar];
    self.navbar = navbar;
}

- (void)setupWebView{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.height = CBYSCREENH - CBYToolbarHeight;
    webView.opaque = NO;
    webView.delegate = self;
    webView.scrollView.contentInset = UIEdgeInsetsMake(CBYNavigationBarHeight, 0, 0, 0);
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)setupToolBar{
    CBYToolbar *bar = [[CBYToolbar alloc] init];
    bar.frame = self.view.bounds;
    bar.y = self.view.height - CBYToolbarHeight;
    bar.height = CBYToolbarHeight;
    bar.delegate = self;
    
    bar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Browser_Toolbar"]];
    [bar addButtonWithName:@"Browser_Icon1_Back" highImage:@"Browser_Icon1_Back_Highlight" selectedImage:nil disabledImage:nil type:CBYToolbarButtonTypeBack];
    
    [bar addButtonWithName:@"Browser_Icon_Reload" highImage:@"Browser_Icon_Reload_Highlight" selectedImage:nil disabledImage:nil type:CBYToolbarButtonTypeRefresh];
    
    [bar addButtonWithName:@"Browser_Icon_Back" highImage:@"Browser_Icon_Back_Highlight" selectedImage:nil disabledImage:@"Browser_Icon_Back_Disable" type:CBYToolbarButtonTypePrevious];
    
    [bar addButtonWithName:@"Browser_Icon_Forward" highImage:@"Browser_Icon_Forward_Highlight" selectedImage:nil disabledImage:@"Browser_Icon_Forward_Disable" type:CBYToolbarButtonTypeForward];
    
    [bar addButtonWithName:@"Browser_Icon_Action" highImage:@"Browser_Icon_Action_Highlight" selectedImage:nil disabledImage:nil type:CBYToolbarButtonTypeShare];
    
    [self.view addSubview:bar];
    self.toolbar = bar;
}

#pragma mark --- 代理方法
- (void)toolBar:(CBYToolbar *)toolbar buttonType:(CBYToolbarButtonType)type{
    switch (type) {
        case CBYToolbarButtonTypeBack:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case CBYToolbarButtonTypeRefresh:
            [self.webView reload];
            break;
            
        case CBYToolbarButtonTypePrevious:
            [self.webView goBack];
            break;
            
        case CBYToolbarButtonTypeForward:
            [self.webView goForward];
            break;
            
        case CBYToolbarButtonTypeShare:{
            CBYShareController *share = [[CBYShareController alloc] init];
            [share showAboveView:[UIApplication sharedApplication].keyWindow];
            [self addChildViewController:share];
        }
            break;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.navbar dataDidStartLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.navbar dataDidFinishLoad:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    self.toolbar.canGoNext = [webView canGoForward];
    self.toolbar.canGoPrevious = [webView canGoBack];
}

- (void)navBar:(CBYNavBar *)navbar{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
