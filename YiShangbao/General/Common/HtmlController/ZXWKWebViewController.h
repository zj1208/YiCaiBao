//
//  ZXWKWebViewController.h
//  YiShangbao
//
//  Created by simon on 2019/11/18.
//  Copyright © 2019 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString* const SixSpaces = @"      ";

@interface ZXWKWebViewController : UIViewController

@property (nonatomic, strong) WKWebView  *webView;


// 初始化;指定固定标题
- (instancetype)initWithBarTitle:(nullable NSString *)aTitle;
// 标题-保证默认分享的时候能取到标题和链接
@property (nonatomic, copy) NSString *barTitle;


//1.网络地址
@property (nonatomic, copy) NSString *webURLString;


// 右侧分享按钮
@property (nonatomic, strong) UIBarButtonItem *shareButtonItem;
// 右侧更多按钮
//@property (nonatomic, strong)UIBarButtonItem *moreButtonItem;

// navigation的URL数组,一个页面出现多个请求的时候；
@property (nonatomic, strong) NSMutableArray *navigationUrlsMArray;

//进度条
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) WKUserContentController *userContentContorller;

//h5跳原生后，从堆栈中移除
@property (nonatomic, assign) BOOL needDellocH5;


//1.加载网络html页面
- (void)loadWebPageWithURLString:(NSString *)urlString;

/**
 2.加载本地html网页
 
 @param name 本地HTML文件名
 */
- (void)loadWebHTMLSringWithResource:(NSString *)name;

//3.加载本地html字符串
- (nullable WKNavigation *)loadHTMLString:(NSString *)html baseURL:(nullable NSURL *)baseURL;

//4.加载本地文件数据 有bug；无法实现；

- (void)loadFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType NS_AVAILABLE_IOS(9_0);

//5. 加载纯文本数据在webView显示
- (void)loadLocalText:(NSString *)content NS_AVAILABLE_IOS(9_0);




// 刷新最新数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END


// 当需要放到tabBar主页面的时候
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布求购";
    WYWKWebViewController *moreVc = [[WYWKWebViewController alloc] init];
    moreVc.webUrl = [NSString stringWithFormat:@"%@/ycb/page/ycbPurchaseForm.html",[WYUserDefaultManager getkAPP_H5URL]];
    [self addChildViewController:moreVc];
    [self.view addSubview:moreVc.view];
}
*/
