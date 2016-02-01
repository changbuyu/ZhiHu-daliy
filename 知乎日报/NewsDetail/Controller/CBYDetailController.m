//
//  CBYDetailController.m
//  知乎日报
//
//  Created by 常布雨 on 16/1/18.
//  Copyright © 2016年 CBY. All rights reserved.

#import "CBYDetailController.h"
#import "CBYDetail.h"
#import "CBYDetailTopView.h"
#import "CBYNewsTool.h"
#import "MJRefresh.h"
#import "CBYWebViewController.h"
#import "CBYRecommenderView.h"
#import "Masonry.h"
@interface CBYDetailController ()<UIWebViewDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) CBYDetailTopView *topView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) CGFloat oldOffset;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *lastLabel;
@property (nonatomic, weak) MJRefreshNormalHeader *header;
@property (nonatomic, weak) MJRefreshFooter *footer;
@property (nonatomic, weak) CBYRecommenderView *recommendView;
@end

@implementation CBYDetailController

- (UILabel *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.text = @"这已经是第一篇了";
        [_firstLabel sizeToFit];
        _firstLabel.font = MJRefreshLabelFont;
        _firstLabel.textColor = [UIColor whiteColor];
        _firstLabel.textAlignment = NSTextAlignmentCenter;
        self.firstLabel.centerX = self.view.centerX;
        self.firstLabel.centerY = - CBYNavigationBarHeight * 0.5;
    }
    return _firstLabel;
}

- (UILabel *)lastLabel{
    if (!_lastLabel) {
        _lastLabel = [UILabel label];
        _lastLabel.font = MJRefreshLabelFont;
        _lastLabel.text = @"这已经是最后一篇了";
        [_lastLabel sizeToFit];
        _lastLabel.textColor = [UIColor lightGrayColor];
        _lastLabel.textAlignment = NSTextAlignmentCenter;
        self.lastLabel.centerX = self.view.centerX;
    }
    return _lastLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    //添加webView
    [self setupWebView];
    //添加顶部视图
    [self setupTopView];
    //添加推荐者视图
#warning 需用js来调整网页间距------后续改进
//    [self setupRecommenderView];
    //添加下拉返回上一篇新闻, 上拉加载下一篇新闻
    [self setupHeaderAndFooter];
    
}



#pragma mark ---- 初始化方法
- (void)setupWebView{
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.height = CBYSCREENH - CBYToolbarHeight;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.scrollView.delegate = self;
    webView.opaque = NO;
    [self.view addSubview:webView];
    self.webView = webView;
    
    self.oldOffset = webView.scrollView.contentOffset.y;
    
}
/**
 *  添加顶部视图
 */
- (void)setupTopView{
    CBYDetailTopView *top = [[CBYDetailTopView alloc] init];
    top.frame = self.view.bounds;
    top.height = CBYTopViewHeight - CBYNavigationBarHeight;
    [self.webView.scrollView addSubview:top];
    self.topView = top;
}
/**
 *  添加推荐者视图
 */
- (void)setupRecommenderView{
    CBYRecommenderView *recommend = [[CBYRecommenderView alloc] init];
    [self.view addSubview:recommend];
    self.recommendView = recommend;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(CBYToolbarHeight);
        make.top.equalTo(self.topView.mas_bottom);
    }];
}

- (void)setupHeaderAndFooter{
    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.delegate detailController:self options:CBYDetailOptionsPrevious];
    }];
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *) self.webView.scrollView.mj_header;
    header.arrowView.image = [UIImage imageNamed:@"ZHAnswerViewBack"];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = [UIColor whiteColor];
    self.header = header;
    
    self.webView.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.delegate detailController:self options:CBYDetailOptionsNext];
    }];
    self.footer = self.webView.scrollView.mj_footer;
}

-(void)loadDetail:(CBYDetail *)detail css:(NSString *)css{
    self.topView.detail = detail;
    self.recommendView.recommenders = detail.recommenders;
    /**
     *  判断顶部有没有图片
     */
    if (!detail.image) {
        self.topView.hidden = YES;
    }else{
        self.topView.hidden = NO;
    }
    /**
     *  判断有没有推荐者
     */
    if (!detail.recommenders) {
        self.recommendView.hidden = YES;
    }else{
        self.recommendView.hidden = NO;
    }
    NSString *htmlUrl = [NSString stringWithFormat:@"<html><head><style type = \"text/css\">%@</style></head><body>%@</body></html>",css,detail.body];
    [self.webView loadHTMLString:htmlUrl baseURL:nil];
    self.webView.transform = CGAffineTransformIdentity;

    [self.header endRefreshing];
    [self.footer endRefreshing];
}

#pragma mark ---- webView的代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //调整字号
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str = request.URL.absoluteString;
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        NSString *imgURL = [str stringByReplacingOccurrencesOfString:@"myweb:imageClick:" withString:@""];
        [self.delegate detailController:self imgURL:imgURL];
        return YES;
    }else if ([str isEqualToString:@"about:blank"]){
        
    }else{
        CBYWebViewController *web = [[CBYWebViewController alloc] init];
        web.url = str;
        [self.navigationController pushViewController:web animated:YES];
        return NO;
    }
    return YES;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat delta = scrollView.contentOffset.y - self.oldOffset;
    self.delta = delta;
    if (delta <= - CBYNavigationBarHeight) {
        scrollView.contentOffset = CGPointMake(0, self.oldOffset - CBYNavigationBarHeight);
    }
    [self changeTopViewTranform:(CGFloat)delta];
    [self changeHeaderAndFooterStatus];
}

/**
 *  判断最上方显示的内容;
 */
- (void)changeHeaderAndFooterStatus{
    if([CBYNewsTool isTheFirstNewsWithIndex:self.index]){
        self.header.hidden = YES;
        [self.webView.scrollView addSubview:self.firstLabel];
    }else{
        self.header.hidden = NO;
        [self.firstLabel removeFromSuperview];
    }
    
    if ([CBYNewsTool isTheLastNewsWithIndex:self.index]) {
        self.footer.hidden = YES;
        self.lastLabel.centerY = self.webView.scrollView.contentSize.height + CBYNavigationBarHeight * 0.5;
        [self.webView.scrollView addSubview:self.lastLabel];
    }else{
        self.footer.hidden = NO;
        [self.lastLabel removeFromSuperview];
    }
}

/**
 *  改变顶部视图的transform
 */
- (void)changeTopViewTranform:(CGFloat)offset{
    if (offset < 0) {
//        self.recommendView.transform = CGAffineTransformIdentity;
        self.topView.height = CBYTopViewHeight - CBYNavigationBarHeight - offset;
        self.topView.y = offset;
//        self.recommendView.transform = CGAffineTransformMakeTranslation(0, - offset);
        if (offset <= - CBYNavigationBarHeight) {
            self.topView.height = CBYTopViewHeight;
            self.topView.y = - CBYNavigationBarHeight;
//            self.recommendView.transform = CGAffineTransformMakeTranslation(0, CBYNavigationBarHeight);
        }
    }else{
    }
}

@end
