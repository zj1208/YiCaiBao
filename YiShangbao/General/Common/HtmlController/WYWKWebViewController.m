//
//  WYWKWebViewController.m
//  YiShangbao
//
//  Created by simon on 2019/11/18.
//  Copyright © 2019 com.Microants. All rights reserved.
//

#import "WYWKWebViewController.h"

#import "WKWebViewJavascriptBridge.h"
#import "XLPhotoBrowser.h"

@interface WYWKWebViewController ()<XLPhotoBrowserDatasource,XLPhotoBrowserDelegate>

@property WKWebViewJavascriptBridge *bridge;

// 业务需要集合数据
@property (nonatomic, strong) NSMutableDictionary *rightBtnJsDic;
@property (nonatomic, strong) NSMutableDictionary *rRightBtnDic;
@property (nonatomic, strong) NSMutableDictionary *lRightBtnDic;

@property(nonatomic, copy) NSArray *picArray; //大图预览数组
@property(nonatomic, copy) NSArray *imagesProcutsArray; //大图+产品预览数组

@end

@implementation WYWKWebViewController

- (void)viewDidLoad {
    //设置userAgent-必须第一
    [self userAgent];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];

    [self buildUI];
    
    [self setData];
    
    //建立桥接
    [self addWebViewJavascriptBridge];
}


#pragma mark - 设置user-agent

-(void)userAgent
{
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newAgent = nil;
    // microants-xx-版本号
    NSString *customString = [NSString stringWithFormat:@"microants-%ld-%@",(long)[WYUserDefaultManager getUserTargetRoleType],APP_Version];
    NSRange range = [oldAgent rangeOfString:@"microants"];
    if (range.location != NSNotFound)
    {
        NSArray *array = [oldAgent componentsSeparatedByString:@"microants"];
        newAgent = [NSString stringWithFormat:@"%@%@",array[0],customString];
    }
    else
    {
        newAgent = [oldAgent stringByAppendingString:customString];
    }
    if (@available(iOS 9.0,*))
    {
        self.webView.customUserAgent = newAgent;
    }
    else
    {
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
}

#pragma mark - UI加载
-(void)buildUI
{
    [self setLoadTitle];
    
    NSRange rangeCFB = [self.URLString rangeOfString:@"pingan.com"];
    NSRange rangeDuiBa = [self.URLString rangeOfString:@"duiba.com.cn"];
    // 屏蔽兑吧域名，兑吧界面不展示分享
    if(rangeDuiBa.location == NSNotFound && rangeCFB.location == NSNotFound)
    {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SixSpaces style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];//默认6个空格占位，空格太少按钮宽度过小，title切换至“分享”过渡效果不太好
        self.shareButtonItem = rightBarButtonItem;
        self.shareButtonItem.enabled = NO;
        [self.navigationItem setRightBarButtonItems:@[self.shareButtonItem] animated:NO];
    }
    
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) {
        self.progressView.progressTintColor = [UIColor colorWithHexString:@"FF5434"];
    }else{
        self.progressView.progressTintColor = [UIColor colorWithHexString:@"F58F23"];
    }
}

- (void)setLoadTitle
{
    NSRange rangeCFB = [self.URLString rangeOfString:@"pingan.com"];
    if (rangeCFB.location != NSNotFound)
    {
        self.barTitle = NSLocalizedString(@"平安财富宝理财专区", nil);
    }
    self.navigationItem.title = self.barTitle;
}






//分享
-(void)shareAction:(id)sender
{
    // 默认图片地址
    NSString *picStr = @"http://public-read-bkt-oss.oss-cn-hangzhou.aliyuncs.com/app/icon/logo_zj.png";
    NSString *link =nil;
    if (self.urlArrayM.count>0) {
        NSURL* url = self.urlArrayM.firstObject;
        link =url.absoluteString;
    }else{
        link = self.webView.URL.absoluteString;
    }
    [WYShareManager shareInVC:self withImage:picStr withTitle:self.navigationItem.title withContent:@"用了义采宝，生意就是好!" withUrl:link];
}


- (void)setData
{
    _rightBtnJsDic = [NSMutableDictionary new];
    _lRightBtnDic = [NSMutableDictionary new];
    _rRightBtnDic = [NSMutableDictionary new];
}


- (NSArray *)picArray
{
    if (!_picArray)
    {
        _picArray =[NSArray array];
    }
    return _picArray;
}

- (NSArray *)imagesProcutsArray
{
    if (!_imagesProcutsArray)
    {
        _imagesProcutsArray =[NSArray array];
    }
    return _imagesProcutsArray;
}

#pragma  mark - ---------webViewJavascriptBridge------
-(void)addWebViewJavascriptBridge
{
    
     [WKWebViewJavascriptBridge enableLogging];
       //  实例化WebViewJavascriptBridge,建立JS与OjbC的沟通桥梁
      WKWebViewJavascriptBridge *jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
       // 添加webviewDelegate
      [jsBridge setWebViewDelegate:self];
    self.bridge = jsBridge;
    // JS主动调用OjbC的方法
    //  注册事件名，用于给JS端调用的处理器，并定义用于响应的处理逻辑；
    //  data就是JS所传的参数，不一定需要传,OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    
    //-----结束当前页面(返回上一层)，无参
    WS(weakSelf);
    [self.bridge registerHandler:@"finish" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf finish];
    }];
    //从堆栈中移除并销毁当前H5页面
    [self.bridge registerHandler:@"dellocH5" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf jsDellocH5];
    }];
    
    //----调用分享(share)，参数为分享的标题以及点击的链接地址{'title':xxx,'text':xxx,'link':xxx,'image':xxx}
    [self.bridge registerHandler:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf share:data];
    }];
    //----跳转到大图浏览(previewImages)，参数为下标和图片数组
    [self.bridge registerHandler:@"previewImages" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf previewImages:data];
    }];
    //----设置标题（setTitle)
    [self.bridge registerHandler:@"setTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf setNavTitle:data];
    }];
    //----设置导航右侧按钮(setRight)
    [self.bridge registerHandler:@"setRight" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf setRight:data];
    }];
    //----js跳转native页面
    [self.bridge registerHandler:@"route" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf route:data];
        
    }];
    
    //产品管理列表状态更新
    [self.bridge registerHandler:@"productChangeType" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf postNotiToProdectList];
    }];
    //反馈给js传值value
    [self.bridge registerHandler:@"h5NeedData" handler:^(id data, WVJBResponseCallback responseCallback) {
 
        [weakSelf h5NeedData:responseCallback];
    }];
}

//- (WKWebViewJavascriptBridge *)bridge
//{
//    if (!_bridge) {
//
//        //WebViewJavascriptBridge
//        // 开启日志
//        [WKWebViewJavascriptBridge enableLogging];
//        //  实例化WebViewJavascriptBridge,建立JS与OjbC的沟通桥梁
//        WKWebViewJavascriptBridge *jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
//        // 添加webviewDelegate
//        [jsBridge setWebViewDelegate:self];
//        _bridge = jsBridge;
//    }
//    return _bridge;
//}

#pragma mark - JS调用原生方法实现
//1.结束当前页面(finish)，无参
- (void)finish{
    [self.navigationController popViewControllerAnimated:YES];
}

//2.调用分享(share)，参数为分享的标题以及点击的链接地址
-(void)share:(NSDictionary *)dic
{
    NSString *picStr = [dic objectForKey:@"image"];
    NSString *title = [dic objectForKey:@"title"];
    NSString *content = [dic objectForKey:@"text"];
    NSString *link = [dic objectForKey:@"link"];
    [WYShareManager shareInVC:self withImage:picStr withTitle:title withContent:content withUrl:link];
}

//3.跳转到大图浏览(previewImages)，参数:下标和图片数组,兼容h5前后版本字段；
-(void)previewImages:(NSDictionary *)dic{
    //大图浏览
    id images = [dic objectForKey:@"images"];
    id imagesProducts = [dic objectForKey:@"products"];
    if (!images || ![images isKindOfClass:[NSArray class]]) {//一定有，老版本使用该字段
        [MBProgressHUD zx_showError:@"images empty!" toView:self.view];
        return;
    }
    if (imagesProducts && ![imagesProducts isKindOfClass:[NSArray class]]) {
        [MBProgressHUD zx_showError:@"images Products is not Array!" toView:self.view];
        return;
    }
    NSInteger index = [[dic objectForKey:@"position"] integerValue];
    self.picArray = [NSArray arrayWithArray:images];
    self.imagesProcutsArray = [NSArray arrayWithArray:imagesProducts];
    NSInteger count = self.imagesProcutsArray.count>0?self.imagesProcutsArray.count:self.picArray.count;
    
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoAndProductBrowserWithCurrentImageIndex:index  imageCount:count goodsUrlList:[self getGoodsUrlList] datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
//    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:_picArray.count datasource:self];
//    browser.browserStyle = XLPhotoBrowserStyleCustom;
//    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
}

#pragma mark  XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{

    if (self.imagesProcutsArray.count>0) {
        NSDictionary *objc = self.imagesProcutsArray[index];
        NSURL *url = [NSURL URLWithString:[objc objectForKey:@"image"]];
        return url;
    }else{
        NSURL *url = [NSURL URLWithString:self.picArray[index]];
        return url;
    }
}
-(NSArray *)getGoodsUrlList
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i=0; i<self.imagesProcutsArray.count; ++i) {
        XLPhotoUrlModel *model = [[XLPhotoUrlModel alloc] init];
        NSDictionary *objc = self.imagesProcutsArray[i];
        NSString *link = [objc objectForKey:@"link"];
        if (![NSString zhIsBlankString:link]) {
            model.goodsUrl = link;
        }
        [arrayM addObject:model];
    }
    return arrayM;
}

//4.设置标题（setTitle)
-(void)setNavTitle:(NSDictionary *)dic{
    self.navigationItem.title = [dic objectForKey:@"title"];
}

//5.设置导航右侧按钮(setRight),图标放在本地，图标名字h5中去；
-(void)setRight:(NSDictionary *)dic
{
    _rightBtnJsDic = [dic mutableCopy];
    NSArray *btnArray = [dic objectForKey:@"items"];
    if (btnArray.count == 1)
    {
        self.rRightBtnDic = btnArray[0];
        UIBarButtonItem *item = [self jsBarBtnWithButtonDic:self.rRightBtnDic action:@selector(rRightbtnAction:)];
        [self.navigationItem setRightBarButtonItem:item animated:NO];
    }
    else if (btnArray.count == 2)
    {
        self.lRightBtnDic = btnArray[0];
        UIBarButtonItem *rightBarBtnItem1 = [self jsBarBtnWithButtonDic:self.lRightBtnDic action:@selector(lRightbtnAction:)];
     
        self.rRightBtnDic = btnArray[1];
        UIBarButtonItem *rightBarBtnItem2 = [self jsBarBtnWithButtonDic:self.rRightBtnDic action:@selector(rRightbtnAction:)];
        NSArray *items = @[rightBarBtnItem2,rightBarBtnItem1];
        [self.navigationItem setRightBarButtonItems:items animated:YES];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = nil;
    }
}

- (UIBarButtonItem *)jsBarBtnWithButtonDic:(NSDictionary *)btnDic action:(SEL)action
{
    NSString *icon = [btnDic objectForKey:@"icon"];
    UIBarButtonItem *barButtonItem = nil;
    if (icon.length)
    {
        barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:action];
    }else
    {
        barButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self.rRightBtnDic objectForKey:@"text"] style:UIBarButtonItemStylePlain target:self action:action];
    }
    return barButtonItem;
}

#pragma mark 右侧导航按钮事件
-(void)rRightbtnAction:(UIBarButtonItem *)sender
{
    NSString *idstr = [self.rRightBtnDic objectForKey:@"id"];
    NSString *successStr = [self.rightBtnJsDic objectForKey:@"onSuccess"];
    NSString *str = [NSString stringWithFormat:@"(%@)(%@)",successStr,idstr];
    [self.webView evaluateJavaScript:str completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    }];
    
}

-(void)lRightbtnAction:(UIBarButtonItem *)sender
{
    NSString *idstr = [self.lRightBtnDic objectForKey:@"id"];
    NSString *successStr = [self.rightBtnJsDic objectForKey:@"onSuccess"];
    NSString *str = [NSString stringWithFormat:@"(%@)(%@)",successStr,idstr];
    [self.webView evaluateJavaScript:str completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    }];
}

//6.js跳转native页面
-(void)route:(NSDictionary *)dic{
    
    [[WYUtility dataUtil]routerWithName:[dic objectForKey:@"url"] withSoureController:self];
}

//7.从堆栈中移除并销毁当前H5页面
-(void)jsDellocH5
{
    self.needDellocH5 = YES; //3.1.0版本后开始使用该方法标记再移除,之前版本使用下方法，但下方法不能H5加载过程中进行跳转销毁
//    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
//    [arrayM removeObject:self];
//    [self.navigationController setViewControllers:arrayM animated:NO];
}

// 8.更新产品列表
- (void)postNotiToProdectList
{
    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePrivacy object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updatePublic object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ProductManager_updateSoldouting object:nil];
}

// 9.h5需要的数据
- (void)h5NeedData:(WVJBResponseCallback)responseCallback
{
    NSString *idfa = [[UIDevice currentDevice]zx_getIDFAUUIDString];
    NSDictionary *dic = @{@"deviceId":idfa};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    responseCallback(jsonString);
}

@end
