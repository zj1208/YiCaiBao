//
//  ZXWKWebViewController.m
//  YiShangbao
//
//  Created by simon on 2017/10/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXWKWebViewController.h"

#import "ZXEmptyViewController.h"

#import "WKWebViewJavascriptBridge.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZXHTTPCookieManager.h"

typedef NS_ENUM(NSInteger, WebLoadType) {
    
    WebLoadType_URLString =0,//网络html地址
    WebLoadType_LocalHTMLFile =1,//本地html文件
    WebLoadType_LocalFileContent = 2,//本地纯文本文件
    WebLoadType_LocalFile =3, //本地文件
};


@interface ZXWKWebViewController ()<WKNavigationDelegate,WKUIDelegate,
 ZXEmptyViewControllerDelegate,UIGestureRecognizerDelegate>

// 导航条按钮;
// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
// 关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
// 填充间距按钮
@property (nonatomic, strong) UIBarButtonItem *negativeSpacerItem;


// 空视图；
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property WKWebViewJavascriptBridge *bridge;

//加载类型
@property (nonatomic) WebLoadType webLoadType;

//2.本地文件资源
//文件名/或本地html名
@property (nonatomic, copy) NSString *localFileName;
//文件类型
@property (nonatomic, copy) NSString *localFileType;
@property (nonatomic, copy) NSString *localFileMimeType;
//3.本地文件txt数据
@property (nonatomic, copy) NSString *localTxtFileContent;

@end

@implementation ZXWKWebViewController

#pragma mark - life cycle

- (instancetype)initWithBarTitle:(NSString *)aTitle{
    self = [super init];
    if (self)
    {
        self.barTitle = aTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self zxSetUI];
    
    //初始化数据
    [self zxSetData];
    
    //根据不同业务加载数据
    [self webViewRequestLoadType];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.presentedViewController && ([self.presentedViewController isKindOfClass:[UIImagePickerController class]] || [self.presentedViewController isKindOfClass:[UIDocumentPickerViewController class]]))
    {//h5调用系统相册、相机、文件系统后不resume
    }else{
        [self resume];//h5内路由跳转原生后，返回回来的时候，通知H5刷新页面
    }

    if (self.navigationController.viewControllers.count>1)
    {
       self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

//resume事件-重新展示h5的controller页面的时候，调用js方法通知h5是否执行刷新数据页面
-(void)resume
{
    NSString *str = [NSString stringWithFormat:@"(function () {var event = new Event('resume');document.dispatchEvent(event);})()"];
    [self.webView evaluateJavaScript:str completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"obj = %@,error =%@",obj,error);
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.webView.scrollView flashScrollIndicators];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.navigationController.navigationBar setShadowImage:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.needDellocH5)
    {
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
        [arrayM removeObject:self];
        [self.navigationController setViewControllers:arrayM animated:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"dealloc");
    self.webView.navigationDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(URL))];
}

#pragma mark - UI加载
-(void)zxSetUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
    //设置导航条
    [self setupNav];
    //添加WKWebView；
    [self.view addSubview:self.webView];
    //添加进度条
    [self.view addSubview:self.progressView];
    
    self.emptyViewController.view.frame = self.view.frame;

    if ([[UIDevice currentDevice] systemVersion].floatValue <9.f){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
        [self addConstraint:self.webView toSuperviewItem:self.view];
    }
}

#pragma mark -初始化导航条
- (void)setupNav
{
    self.navigationItem.title = self.barTitle;
    //不要用animated，不然有bug
    self.navigationItem.leftBarButtonItems = @[self.backButtonItem,self.negativeSpacerItem];
}

#pragma mark -初始化WebView,progressView,EmptyVC

- (WKWebView *)webView
{
    if (!_webView)
    {
        WKUserContentController *contentContorller = [[WKUserContentController alloc] init];
        
//        // 注入一个cookie用户脚本；
//        NSString *source = [NSString stringWithFormat:@"document.cookie = 'mat = %@'",[UserInfoUDManager getToken]];
//        WKUserScript *cookieScript =  [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//        [contentContorller addUserScript:cookieScript];
        
        //不能乱设置，不然布局会乱
        WKPreferences *preferences = [[WKPreferences alloc] init];
        //默认值
        preferences.minimumFontSize = 0.f;
        preferences.javaScriptEnabled = YES;
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = contentContorller ;
        configuration.preferences = preferences;
        configuration.allowsInlineMediaPlayback = YES;
        //ios9以上
        if ([configuration respondsToSelector:@selector(allowsPictureInPictureMediaPlayback)])
        {
            configuration.allowsPictureInPictureMediaPlayback = YES;
        }
        if ([configuration respondsToSelector:@selector(allowsAirPlayForMediaPlayback)])
        {
            configuration.allowsAirPlayForMediaPlayback  = YES;
        }
        // 音乐自动播放；iOS10
        if (@available(iOS 10.0,*))
        {
            if ([configuration respondsToSelector:@selector(mediaTypesRequiringUserActionForPlayback)])
            {
                configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
            }
            if ([configuration respondsToSelector:@selector(dataDetectorTypes)])
            {
                configuration.dataDetectorTypes = !WKDataDetectorTypeAddress;
            }
        }
        else
        {
            // ios9
            if ([configuration respondsToSelector:@selector(requiresUserActionForMediaPlayback)])
            {
                configuration.requiresUserActionForMediaPlayback = NO;
            }
            // ios8
            if ([configuration respondsToSelector:@selector(mediaPlaybackRequiresUserAction)])
            {
                configuration.mediaPlaybackRequiresUserAction = NO;
            }
        }
        
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAVBAR, LCDW, LCDH-HEIGHT_NAVBAR-HEIGHT_TABBAR_SAFE) configuration:configuration]; //设置frame来调整，用wkWebView.scrollView.contentInset会引起H5底部参考点出错
        wkWebView.backgroundColor = self.view.backgroundColor;
        wkWebView.allowsBackForwardNavigationGestures = YES;
        wkWebView.allowsLinkPreview = YES;
        wkWebView.navigationDelegate = self;
        wkWebView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView = wkWebView;
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0,HEIGHT_NAVBAR, self.view.bounds.size.width, 2);
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"FF5434"];

//        if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) {
//            _progressView.progressTintColor = [UIColor colorWithHexString:@"FF5434"];
//        }else{
//            _progressView.progressTintColor = [UIColor colorWithHexString:@"F58F23"];
//        }
    }
    return _progressView;
}


- (ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
        emptyVC.delegate = self;
        _emptyViewController = emptyVC;
    }
    return _emptyViewController;
}

#pragma mark - initData初始化数据

//初始化数据
- (void)zxSetData
{
    [self addObserver];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo:) name:Noti_ProductManager_Edit_goBackUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(managerCookiesChanged:) name:NSHTTPCookieManagerCookiesChangedNotification object:nil];
}

#pragma mark 添加KVO观察者

- (void)addObserver
{
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(URL)) options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark -KVO的监听代理

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //加载进度值
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setAlpha:1.0f];
            BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
            if (animated)
            {
                [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
            }
            if(self.webView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progressView setAlpha:0.0f];
                                 }completion:^(BOOL finished) {
                                     [self.progressView setProgress:0.0f animated:NO];
                                     [self.navigationController.navigationBar setShadowImage:nil];
                                 }];
            }
        });
    
    }
    //网页title
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))] && object ==self.webView)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!self.barTitle && self.webView.title.length>0)
            {
                self.navigationItem.title = self.webView.title;
            }
        });
   
    }
    //网页url
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(URL))] && object ==self.webView)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.webView.URL) {
                [self.urlArrayM addObject:self.webView.URL];
            }
        });
 
        NSLog(@">>%@",self.webView.URL);
        NSLog(@"<<%@",self.urlArrayM);
    }
}


- (NSMutableArray *)urlArrayM
{
    if (!_urlArrayM)
    {
        _urlArrayM = [NSMutableArray array];
    }
    return _urlArrayM;
}

#pragma mark-通知selector

- (void)managerCookiesChanged:(id)notification
{
    
}
- (void)updateInfo:(id)notification
{
    [self.webView reload];
}
- (void)loginIn:(id)notification
{
    if (Device_SYSTEMVERSION.floatValue<11)
    {
        // 为了解决登陆完，cookie还没有被写进浏览器；
        [MBProgressHUD zx_showSuccess:@"登陆成功，正在刷新数据" toView:self.view hideAfterDelay:2.5f];
        [self.webView performSelector:@selector(reload) withObject:nil afterDelay:2.5f];
    }
    else
    {
        if (@available(iOS 11.0, *))
        {
            WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
            NSHTTPCookie *cookie = [[ZXHTTPCookieManager sharedInstance]getHTTPCookieFromNSHTTPCookieStorageWithCookieName:@"mat"];
            [cookieStore setCookie:cookie completionHandler:^{
            }];
        }
        [self.webView reload];
    }
}

#pragma mark - 加载各种不同数据;响应不同加载：真正请求数据

- (void)webViewRequestLoadType
{
    switch (self.webLoadType)
    {
        case WebLoadType_URLString:
            [self loadRequestWebPageWithURLString];
            break;
        case WebLoadType_LocalFile:
            [self loadRequestFileResource:self.localFileName ofType:self.localFileType MIMEType:self.localFileMimeType];
            break;
        case WebLoadType_LocalFileContent:
            [self loadRequestLocalText:self.localTxtFileContent];
            break;
        case WebLoadType_LocalHTMLFile:
            [self loadRequestLocalHTMLWithResource:self.localFileName];
            break;
        default:
            break;
    }
}


#pragma mark-加载纯外部链接网页

- (void)loadRequestWebPageWithURLString
{
    NSURL *url = [self getCurrentWebPageNewURL];
    NSLog(@"url = %@",[url absoluteString]);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    // 即使请求头有cookie-mat，请求response服务器反应也没有cookie-mat？
//    NSString *cookie = [[ZXHTTPCookieManager sharedInstance]getCurrentRequestCookieHeaderForURL:url];
//    [request setValue:cookie forHTTPHeaderField:@"Cookie"];
//    [self.webView loadRequest:request];
    
    if (@available(iOS 11.0, *))
    {
        WKWebsiteDataStore *websiteDataStore = self.webView.configuration.websiteDataStore;
        WKHTTPCookieStore *cookieStore  = websiteDataStore.httpCookieStore;
        //这个cookie一直是最新的
        NSHTTPCookie *cookie = [[ZXHTTPCookieManager sharedInstance]getHTTPCookieFromNSHTTPCookieStorageWithCookieName:@"mat"];
//         NSLog(@"%@",cookie);
        if (!cookie)
        {
            [self.webView loadRequest:request];
            return;
        }
//        [MBProgressHUD zx_showSuccess:[NSString stringWithFormat:@"%@",@(self.navigationController.viewControllers.count)] toView:nil];

 
//      3.29 修改第二个wkWebView无法加载请求的bug；
//        当已经加载过WKWebViewController，也存在容器中；再添加第二个WKWebViewController到容器中，会导致WKHTTPCookieStore的方法失效，且所有block都无法返回；第二个无法加载请求的bug；
        __block BOOL loadedWkWebView = NO;
        if (self.navigationController.viewControllers.count>=2)
        {
            NSArray *arr = [self.navigationController.viewControllers subarrayWithRange:NSMakeRange(0, self.navigationController.viewControllers.count-1)];
            [arr enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                if ([obj isKindOfClass:[ZXWKWebViewController class]])
                {
                    loadedWkWebView = YES;
                }
            }];
            if (loadedWkWebView)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_webView loadRequest:request];

                });
            }
            else
            {
                [cookieStore setCookie:cookie completionHandler:^{

                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.webView loadRequest:request];
                        
                    });
                }];
            }
        }
        else
        {
            [cookieStore setCookie:cookie completionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self.webView loadRequest:request];
                });

            }];
        }
    }
    else
    {
        // 即使请求头有cookie-mat，请求response服务器反应也没有cookie-mat？
        NSString *cookie = [[ZXHTTPCookieManager sharedInstance]getCurrentRequestCookieHeaderForURL:url];
        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
        [self.webView loadRequest:request];
    }
}

- (NSURL *)getCurrentWebPageNewURL
{
    NSURL *url = nil;
    
    // 如果是自己公司域名
    if ([self.URLString hasPrefix:[WYUserDefaultManager getkAPP_H5URL]])
    {
        if ([self.URLString rangeOfString:@"{token}"].location != NSNotFound)
        {
            NSString *token = ISLOGIN?[UserInfoUDManager getToken]:@"";
            self.URLString = [self.URLString stringByReplacingOccurrencesOfString:@"{token}" withString:token];
        }
        url = [NSURL zhURLWithString:self.URLString queryItemValue:[BaseHttpAPI getCurrentAppVersion] forKey:@"ttid"];
    }
    // 如果是平安域名-
    else if ([self.URLString hasPrefix:@"https://ncfb-stg3.pingan.com.cn"] ||[self.URLString hasPrefix:@"https://cfb.pingan.com"])
    {
        url = [NSURL URLWithString:self.URLString];
    }
    else
    {
        NSString * string= [self.URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:string];
    }
    return url;
}



//加载本地文件资源：- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
- (void)loadRequestFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (Device_SYSTEMVERSION_IOS9_OR_LATER)
    {
        [self.webView loadData:data MIMEType:mimeType characterEncodingName:@"UTF-8" baseURL:url];
    }
}


//加载本地txt文件的text文本
- (void)loadRequestLocalText:(NSString *)content
{
    // 判断是否可以无损转化编码
    if ([content canBeConvertedToEncoding:NSUTF8StringEncoding])
    {
        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]];
        
        if (Device_SYSTEMVERSION_IOS9_OR_LATER)
        {
            [self.webView loadData:data MIMEType:@"text/plain" characterEncodingName:@"UTF-8" baseURL:url];
        }
    }
}

//加载本地html文件

- (nullable WKNavigation *)loadRequestLocalHTMLWithResource:(NSString *)name{
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
   return  [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

//没有验证过；
- (nullable WKNavigation *)loadHTMLString:(NSString *)html baseURL:(nullable NSURL *)baseURL{
    //加载js
   return  [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}


#pragma mark - ------------------------WKWebView Delegate-------------------------
#pragma mark WKNavigationDelegate


// 1 在发送请求之前，决定是否请求
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"1.在发送请求之前，决定是否请求跳转:%@",navigationAction.request);
    NSURLRequest *request = navigationAction.request;
//    NSLog(@"wkWebViewAllHTTPHeaderFieldes = %@",request.allHTTPHeaderFields);
    // 阿里支付加载
    if ([self payWithAliPayWithRequest:request])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // 超链接
    else if ([self decidePolicyForNavigationActionWithNotHttpRequest:request])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // itunes跳转
    else if ([self decidePolicyForNavigationActionWithGoItunesRequest:request])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 处理超链接
- (BOOL)decidePolicyForNavigationActionWithNotHttpRequest:(NSURLRequest *)request
{
    if ([[UIApplication sharedApplication] canOpenURL:request.URL] && ![request.URL.scheme isEqualToString:@"http"]&& ![request.URL.scheme isEqualToString:@"https"])
    {
        if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
        {
            [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        return YES;
    }
    return NO;
}
//  itunes跳转
- (BOOL)decidePolicyForNavigationActionWithGoItunesRequest:(NSURLRequest *)request
{
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByRemovingPercentEncoding];//解析url
    
    if ([urlString hasPrefix:@"https://itunes.apple.com"])
    {
        if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
        {
            [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:^(BOOL success) {
            }];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        if ([self.webView canGoBack])
        {   // 返回时空白页问题
            [self.webView goBack];
        }
        return YES;
    }
    return NO;
}

// 2 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"2.页面开始加载时调用");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// 3 在收到服务器响应后，决定导航响应策略是否加载； 即使请求头有cookie，响应为何无cookie?
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    [self updateNavigationItems];
    NSLog(@"3.在收到响应后，决定是否加载");
    //能读取到，但是没有存入NSHTTPCookieStorage
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
//    NSString *cookieString =  [[ZXHTTPCookieManager sharedInstance]cookieStringWithResponse:response];
    [[ZXHTTPCookieManager sharedInstance]handleResponseHeaderFields:response.allHeaderFields forURL:response.URL];

    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 4 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"4.当内容开始返回时调用");
}

// 5 页面加载完成之后调用; 即使请求头有cookie-mat，NSHTTPStoreAge有，请求成功回调document.cookie为何没有mat；
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"5.页面加载完成之后调用");
//    NSLog(@"userScript =%@",webView.configuration.userContentController.userScripts);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateNavigationItems];
    [self.urlArrayM removeAllObjects];
    if ([self.shareButtonItem.title isEqualToString:SixSpaces]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.shareButtonItem.enabled = YES; //H5调用setRight方法，偶尔会在didFinishNavigation之后执行（桥异步原因）,导致分享刚出来，又被H5重置rightBarButtonItems;eg：我的收入页面,体验不太好，暂时性解决方案！
            self.shareButtonItem.title = NSLocalizedString(@"分享", nil);
        });
    }
    [self.emptyViewController hideEmptyViewInController:self hasLocalData:YES];
    
    // 真机连数据线有； 不连数据线没有；该方法无法获取到 httponly 的cookie
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.cookie"] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (response != 0) {
            NSLog(@"\n\n\n\n\n\n document.cookie=%@,error=%@",response,error);
        }
    }];
}

// 6 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"6.页面加载失败时调用：%@",error);
  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([error code] == NSURLErrorCancelled)
    {
        NSLog(@"取消");
        return;
    }
    else if ([error code] == 102)
    {
        NSLog(@"帧框加载已中断");
        return;
    }
    NSURL *url = [NSURL URLWithString:[error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]];
    NSURL *appUrl = [NSURL URLWithString:[WYUserDefaultManager getkAPP_H5URL]];
    if([url.host isEqualToString:appUrl.host] ||([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]))
    {
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        return;
    }
}

// 主机地址被重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"主机地址被重定向时调用");
}

// 跳转失败时调用；利用h5的缓存跳转的时候；
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"跳转失败时调用；");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateNavigationItems];
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"需要证书认证");
//    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
//    {
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
//    }
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([challenge previousFailureCount] == 0)
        {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
        else
        {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
    else
    {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

//web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    [webView reload];
    NSLog(@"web内容处理中断时会触发");
}

//#pragma mark - -----------UIDelegate----------
//// 可以指定配置对象、导航动作对象、window特性。如果没有实现这个方法，不会加载链接，如果返回的是原webview会崩溃。
//-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//    NSLog(@"打开新窗口");//什么情况进来？
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//    return nil;
//}
//// webview关闭时回调
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
//- (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0);
//{
//}
//#endif


#pragma mark - alipay支付

- (BOOL)payWithAliPayWithRequest:(NSURLRequest *)request
{
    NSString *appScheme = @"yicaibao";
    WS(weakSelf);
    BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:[request.URL absoluteString] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        [self paymentAlipayResult:resultCode];
        if ([resultCode isEqualToString:@"9000"])
        {
            // returnUrl 代表 第三方App需要跳转的成功页URL
            NSString* urlStr = resultDic[@"returnUrl"];
            if (urlStr.length ==0)
            {
                [self.webView goBack];
            }
            else
            {
                [weakSelf requestWithUrlStr:urlStr];
            }
        }
    }];
  
    return isIntercepted;
}


//支付宝支付结果反馈,可以不展示;失败时不做任何处理
- (void) paymentAlipayResult:(NSString *)code{
    switch (code.integerValue) {
        case 9000:
        {
            [MBProgressHUD zx_showError:@"恭喜您支付成功" toView:self.view];
        }
            break;
        case 8000:
            [MBProgressHUD zx_showError:@"正在处理支付结果，稍后注意查看结果" toView:self.view];
            break;
        case 4000:
            [MBProgressHUD zx_showError:@"支付失败，请重新支付" toView:self.view];
            break;
        case 5000:
            [MBProgressHUD zx_showError:@"您已请求支付，无需重复操作" toView:self.view];
            break;
        case 6001:
            [MBProgressHUD zx_showError:@"您已取消支付" toView:self.view];
            break;
        case 6002:
            [MBProgressHUD zx_showError:@"网络好像有点问题噢，请检查您的网络设置" toView:self.view];
            break;
            // 这个比较模糊，不处理
        case 6004:
            //  [MBProgressHUD zx_showError:@"正在处理支付结果，稍后注意查看结果" toView:self.view];
            break;
        default:
            [MBProgressHUD zx_showError:@"支付失败" toView:self.view];
            break;
    }
}

#pragma mark - 重新加载某个地址
- (void)requestWithUrlStr:(NSString*)urlStr
{
    if (urlStr.length > 0)
    {
        NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
        [self.webView loadRequest:webRequest];
    }
}



#pragma mark - 导航按钮

- (UIBarButtonItem*)backButtonItem{
    if (!_backButtonItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"back_imageTitle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //        UIImage* backItemHlImage = [[UIImage imageNamed:@"back_imageTitle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:NSLocalizedString(@"返回", nil)  forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        //        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        //        [backButton sizeToFit];
        backButton.frame = CGRectMake(0, 0, 50, 44);
//        [backButton zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
        //              [backButton setBackgroundColor:[UIColor redColor]];
        [backButton addTarget:self action:@selector(customBackItemAction:) forControlEvents:UIControlEventTouchUpInside];
        backButton.imageEdgeInsets= UIEdgeInsetsMake(0, 0, 0,floorf(10/2));
        backButton.titleEdgeInsets= UIEdgeInsetsMake(0, floorf(10/2), 0, 0);
//        调整image图标-为了和系统返回统一
//        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _backButtonItem;
}




- (UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [backButton sizeToFit];
        //        [backButton setBackgroundColor:[UIColor redColor]];
        [backButton addTarget:self action:@selector(closeButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _closeButtonItem;
}



//不要用animated，不然有bug；
- (void)updateNavigationItems
{
    if ([self.webView canGoBack])
    {
        NSArray *items = [self zx_navigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem,self.closeButtonItem,self.negativeSpacerItem]];
        [self.navigationItem setLeftBarButtonItems:items animated:NO];
    }
    else
    {
        NSInteger numItems = Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(11)?3:3;
        if (self.navigationItem.leftBarButtonItems.count==numItems)
        {
            NSArray *items = [self zx_navigationItem_leftOrRightItemReducedSpaceToMagin:-7 withItems:@[self.backButtonItem,self.negativeSpacerItem]];
            [self.navigationItem setLeftBarButtonItems:items animated:NO];
        }
    }
    
}
//在iOS11，多增加一个 view
- (UIBarButtonItem *)negativeSpacerItem
{
    if (!_negativeSpacerItem)
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = 10;
        _negativeSpacerItem = negativeSpacer;
    }
    return _negativeSpacerItem;
}

#pragma mark -导航按钮事件

- (void)customBackItemAction:(UIButton *)sender
{
    if ([self.webView canGoBack])
    {
        NSLog(@"goBack");
        [self.webView goBack];
    }
    else
    {
        [self closeButtonItemAction:nil];
    }
}

- (void)closeButtonItemAction:(id)sender
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    if ([self.webView isLoading])
    {
        [self.webView stopLoading];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求失败／列表为空时候的代理请求

- (void)zxEmptyViewUpdateAction
{
    NSURL* url = self.urlArrayM.firstObject;
    [self requestWithUrlStr:url.absoluteString];
}


#pragma mark -  获取自定义当前版本（后台约定）
- (NSString *)getCurrentAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *ttid = [NSString stringWithFormat:@"%@_ysb@iphone",app_Version];
    return ttid;
}


# pragma mark - 刷新当前页面数据
- (void)reloadData
{
    [self.webView reload];
}


#pragma mark - 加载纯外部链接网页
//加载纯外部链接网页
-(void)loadWebPageWithURLString:(NSString *)urlString
{
    self.webLoadType = WebLoadType_URLString;
    if (!urlString)
    {
        return;
    }
    //音乐；
//  self.URLString = @"http://183280454.scene.eqxiu.com/s/3a1oDSh8?eqrcode=1&from=groupmessage&isappinstalled=0";
//    self.URLString = @"http://mp.weixin.qq.com/s/Q1pVsi3w9b98k8gm_WwbjQ";
    self.URLString = urlString;
//    self.URLString = @"http://taobao.com";
//    self.URLString = @"https://faertu.m.tmall.com/shop/shop_auction_search.htm?spm=a222m.7628550.1998338745.1&sort=default";
}

- (void)setWebUrl:(NSString *)webUrl
{
    self.URLString = webUrl;
}
#pragma mark - 加载本地网页

- (void)loadWebHTMLSringWithResource:(NSString *)name
{
    self.localFileName = name;
    self.webLoadType = WebLoadType_LocalHTMLFile;
}

#pragma mark - 加载本地文件数据

//@"test.wps" :@"application/msword"
- (void)loadFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType
{
    if (!name || !mimeType)
    {
        NSLog(@"参数不够");
        return;
    }
    self.localFileName = name;
    self.localFileType = ext;
    self.localFileMimeType = mimeType;
    self.webLoadType = WebLoadType_LocalFile;
}

#pragma mark - 加载本地txt文件的text文本

- (void)loadLocalText:(NSString *)content
{
    self.localTxtFileContent = content;
    self.webLoadType = WebLoadType_LocalFileContent;
}

#pragma mark - UIPreviewActionItem
// 为了保证能分享，title，url链接地址必须外面传值进来
- (NSArray <id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *itemShare = [UIPreviewAction actionWithTitle:NSLocalizedString(@"分享", nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"previewActionShare" object:nil userInfo:@{@"title":self.navigationItem.title,@"url":self.URLString}];
    }];
    return @[itemShare];
}

#pragma constraint

- (void)addConstraint:(UIView *)item toSuperviewItem:(UIView *)superView
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (@available(iOS 11.0, *))         {
        UILayoutGuide *layoutGuide_superView = self.view.safeAreaLayoutGuide;
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:0];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor constant:0];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:0];
        NSLayoutConstraint *constraint_centerX = [item.centerXAnchor constraintEqualToAnchor:layoutGuide_superView.centerXAnchor];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_bottom,constraint_leading,constraint_centerX]];
    }
    else if([[UIDevice currentDevice] systemVersion].floatValue>=9.f)
    {
        // Fallback on earlier versions
        UILayoutGuide *layoutGuide_superView = self.view.layoutMarginsGuide;
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:0];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor constant:0];
        NSLayoutConstraint *constraint_leading = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        //x的center
        NSLayoutConstraint *constraint_centerX = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_bottom,constraint_leading,constraint_centerX]];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




@end

