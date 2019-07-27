    //
//  WYMakeBillPreviewViewController.m
//  YiShangbao
//
//  Created by light on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYMakeBillPreviewViewController.h"
#import <WebKit/WebKit.h>
#import "ContactViewController.h"
#import "MakeBillModel.h"
#import "BillShareView.h"
#import "WYPerfectShopInfoViewController.h"
#import "BillPreviewLoadView.h"
#import "ZXEmptyViewController.h"
@interface WYMakeBillPreviewViewController ()<WKNavigationDelegate,UIPrintInteractionControllerDelegate,ZXEmptyViewControllerDelegate>
@property(nonatomic, strong) WKWebView *wkWebView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UIView *bottonConteentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bCView_bottomLayoutC;
@property (weak, nonatomic) IBOutlet UILabel *shopDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopDescChangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCustomerBtn;

@property(nonatomic, copy) NSString *picPath;
@property(nonatomic, copy) NSString *pdfPath;
@property(nonatomic, copy) NSString *clauseUrl;

@property(nonatomic, copy) NSURL *downloadFileURl;

@property (nonatomic,weak) BillPreviewLoadView *previewLoadView;
@property (nonatomic,weak) BillShareView *shareView;
@property (nonatomic,weak) ZXEmptyViewController *emptyViewController;

@end

@implementation WYMakeBillPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"预览单据";
    [self buildUI];

    [self requestPDFData];
    
    [self addNotificationCenters];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (@available(iOS 12.0, *)) {//跳转下一页返回时空白页bug
        if (self.pdfPath) {
            [self.wkWebView reload];
        }
    }
}
-(void)addNotificationCenters
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestPDFData) name:Noti_updatePDF_WYMakeBillPreviewViewController object:nil];
}
-(void)buildUI
{
    [self hiddenBottonConteentView:YES];

    UIButton *printBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
    [printBtn setTitle:@"打印" forState:UIControlStateNormal];
    printBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [printBtn setTitleColor:[WYUIStyle colorFF5434] forState:UIControlStateNormal];
    [printBtn addTarget:self action:@selector(previewPrintfPDF) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *printBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:printBtn];
    
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [setBtn setTitleColor:[WYUIStyle colorFF5434] forState:UIControlStateNormal];
    UIBarButtonItem *setBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    [setBtn addTarget:self action:@selector(makeBillSet) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[setBarButtonItem,printBarButtonItem];
    
    self.shopDescLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.f)];
    self.shopDescChangeLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.f)];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(17)];//兼容小屏显示
    self.sendCustomerBtn.titleLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(18)];
    UIImage *saveIMG = [WYUIStyle imageFDAB53_FD7953:CGSizeMake(1, 1)];
    UIImage *sendCustomerIMG = [WYUIStyle imageFD7953_FE5147:CGSizeMake(1, 1)];
    [self.saveBtn setBackgroundImage:saveIMG forState:UIControlStateNormal];
    [self.sendCustomerBtn setBackgroundImage:sendCustomerIMG forState:UIControlStateNormal];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 22.5;
    self.sendCustomerBtn.layer.masksToBounds = YES;
    self.sendCustomerBtn.layer.cornerRadius = 22.5;

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.backgroundColor = [WYUISTYLE colorWithHexString:@"e5e5e5"];
    [self.view insertSubview:self.wkWebView belowSubview:self.bottonConteentView];
    if (@available(iOS 11.0, *)){
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIEdgeInsets contentInset = self.wkWebView.scrollView.contentInset;
    contentInset.bottom = 60.f;
    self.wkWebView.scrollView.contentInset = contentInset;
    
    UIEdgeInsets scrollIndicatorInsets = self.wkWebView.scrollView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = 60.f;
    self.wkWebView.scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        if ([WYUserDefaultManager getMakeBilglPreviewSet]) {
            make.top.mas_equalTo(self.view).offset(HEIGHT_NAVBAR);
        }else{
            make.top.mas_equalTo(self.view).offset(HEIGHT_NAVBAR+37);
        }
        make.bottom.mas_equalTo(self.view);
    }];
    
    if ([WYUserDefaultManager getMakeBilglPreviewSet]) {
        [self.topContentView removeFromSuperview];
    }
}
#pragma mark - 获取pdf数据
-(void)requestPDFData
{
    [self performSelector:@selector(showBillPreviewLoadView) withObject:nil afterDelay:0.3];
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillPreviewInfoByBillId:_billId success:^(id data) {
        [self.emptyViewController hideEmptyViewInController:self];
        
        self.picPath = [data objectForKey:@"picPath"];
        self.pdfPath = [data objectForKey:@"pdfPath"];
        self.clauseUrl = [data objectForKey:@"clauseUrl"];

        [self loadWebViewData];
        [self dissBillPreviewLoadView];
       
    } failure:^(NSError *error) {
        [self dissBillPreviewLoadView];
        [self.emptyViewController addEmptyViewInController:self hasLocalData:self.pdfPath?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:[error localizedDescription] updateBtnHide:NO];
    }];
}
-(void)showBillPreviewLoadView
{
    if (self.previewLoadView) {
        [self.previewLoadView removeFromSuperview];
    }
    BillPreviewLoadView *bView = [[BillPreviewLoadView alloc] initWithXib];
    self.previewLoadView = bView;
    [self.view addSubview:self.previewLoadView];
    [self.previewLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(HEIGHT_NAVBAR);
        make.bottom.mas_equalTo(self.view);
    }];
    [self.previewLoadView.jlProgressView simulationProgress];
}
-(void)dissBillPreviewLoadView
{
    if (self.previewLoadView) {
        [self.previewLoadView.jlProgressView simulationEndProgress:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//视觉缓留1.5s
                [self.previewLoadView removeFromSuperview];
            });
        }];
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showBillPreviewLoadView) object:nil];
    }
}
-(void)hiddenBottonConteentView:(BOOL)hidden
{
    if (hidden) {
        self.bCView_bottomLayoutC.constant = -60.f-HEIGHT_TABBAR_SAFE;
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //优化效果
            if (self.bCView_bottomLayoutC.constant!=0) {
                self.bCView_bottomLayoutC.constant = 0;
                [UIView animateWithDuration:0.25 animations:^{
                    [self.view layoutIfNeeded];
                }];
            }
        });
    }
}
#pragma mark - wkwebView加载
-(void)loadWebViewData
{
    if (self.pdfPath) {
        NSURL *url = [NSURL URLWithString:self.pdfPath];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [self.wkWebView loadRequest:request];
    }
}
#pragma WKWebView代理
//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"PDF加载失败：%@",error);
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
    [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:@"加载失败，请重新预览" updateBtnHide:NO];
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [self setWKPDFViewBackgroundColor];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self hiddenBottonConteentView:NO];
}
-(void)setWKPDFViewBackgroundColor
{
    self.wkWebView.scrollView.backgroundColor = [WYUISTYLE colorWithHexString:@"e5e5e5"];
    UIView *ScrollView = self.wkWebView.scrollView;
    for (int i=0; i<ScrollView.subviews.count; ++i) {
        UIView *v = ScrollView.subviews[i];
        if ([NSStringFromClass([v class]) isEqual:@"WKPDFView"]) {
            v.backgroundColor = [WYUISTYLE colorWithHexString:@"e5e5e5"];
        }
    }
}

-(ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        ZXEmptyViewController *emp = [[ZXEmptyViewController alloc] init];
        emp.view.bounds = self.view.bounds;
        emp.contentOffest = CGSizeMake(0, 40);
        emp.delegate = self;
        _emptyViewController = emp;
    }return _emptyViewController;
}
-(void)zxEmptyViewUpdateAction
{
    if (self.pdfPath) {
        [self loadWebViewData];
    }else{
        [self requestPDFData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - 商铺设置关闭
- (IBAction)closeSetBtn:(UIButton *)sender {
    [self.topContentView removeFromSuperview];
    [self.wkWebView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(HEIGHT_NAVBAR);
    }];
    if (![WYUserDefaultManager getMakeBilglPreviewSet]) {
        [WYUserDefaultManager setMakeBillPreviewSet];
    }
}
#pragma mark 商铺设置
- (IBAction)goShopBtn:(id)sender {
    [MobClick event:kUM_kdb_openbill_preview_fix];
    
    if ([UserInfoUDManager isOpenShop]) {  //登陆开店了
        ContactViewController *vc = [[ContactViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{ //登陆未开店
        WYPerfectShopInfoViewController *fastOpenShop = [[WYPerfectShopInfoViewController alloc] init];
        fastOpenShop.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fastOpenShop animated:YES];
    }
}
#pragma mark 保存相册
- (IBAction)saveBtn:(id)sender {
    [MobClick event:kUM_kdb_openbill_preview_save];
    if (self.picPath) {
        SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
        NSURL *url =  [NSURL URLWithString:self.picPath];
        [sdManager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [MBProgressHUD zx_showSuccess:@"保存成功" toView:self.view];
    } else {
        [MBProgressHUD zx_showError:[error description] toView:self.view];
    }
}
#pragma mark 发送给客户
- (IBAction)sendCustomerBtn:(id)sender {
    [MobClick event:kUM_kdb_openbill_preview_share];
    [self requestShareData];
}
#pragma mark - 获取pdf分享H5地址
-(void)requestShareData
{
    self.sendCustomerBtn.enabled = NO;
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillShareByBillId:self.billId success:^(id data) {
        self.sendCustomerBtn.enabled = YES;
        MakeBillShareModel *model = data;
        if (model)
        {
//            BillShareView *view = [[BillShareView alloc] initWithXib];
//            view.frame = self.tabBarController.view.bounds;
//            self.shareView = view;
//            [self.shareView showSuperview:self.tabBarController.view animated:YES];
//
//            self.shareView.shareBlock = ^(SSDKPlatformType shareType) {

                NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
                NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
                NSString *encoded = [self.picPath stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];

                NSString *linrUrl = [model.link stringByReplacingOccurrencesOfString:@"{" withString:@""];
                linrUrl = [linrUrl stringByReplacingOccurrencesOfString:@"}" withString:@""];
                NSURLComponents *components = [[NSURLComponents alloc] initWithString:linrUrl];
                [components jlRemoveObjectForKey:@"pdf"];
                [components zhSetQueryItemValue:encoded forKey:@"img"];
                components.percentEncodedQuery = components.query;//已经编码了，设置不需再编码
                NSString *link = [NSString stringWithFormat:@"%@",components.string];

//                NSString *link_2 = [model.link stringByReplacingOccurrencesOfString:@"{img}" withString:encoded];
//                link_2 = [link_2 stringByReplacingOccurrencesOfString:@"pdf={pdf}&" withString:@""];

                [WYShareManager shareSDKWithShareType:SSDKPlatformSubTypeWechatSession Image:model.pic Title:model.title Content:model.content withPercentEncodedUrl:link];
//            };
        }
    } failure:^(NSError *error) {
        self.sendCustomerBtn.enabled = YES;
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
}
#pragma mark - 打印pdf
-(void)previewPrintfPDF
{
    if (!self.pdfPath) {
        return;
    }
    [self clickFirstPrintf];
}
#pragma mark 第一次使用功能引导
-(void)clickFirstPrintf
{
    BOOL isfirst = [WYUserDefaultManager getMakeBilglPreviewPrintf];
    if (!isfirst) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请将打印机与手机连接至同一wifi下即可打印", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [WYUserDefaultManager setMakeBillPreviewPrintf];
            [self printPDF];//
        }];
        [alertController addAction:doAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self printPDF];
    }
}
-(void)printPDF
{
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        NSURL *fileURL = [NSURL URLWithString:self.pdfPath];
        if ([UIPrintInteractionController canPrintURL:fileURL])
        {
            UIPrintInteractionController *printInteraction = [UIPrintInteractionController sharedPrintController];
            
            UIPrintInfo *printInfo = [UIPrintInfo printInfo];//配置打印信息
            printInfo.duplex = UIPrintInfoDuplexLongEdge; //双面打印绕长边翻页，NONE为禁止双面
            printInfo.outputType = UIPrintInfoOutputGeneral;//可打印文本、图形、图像
//            printInfo.jobName = @"海狮";//可选属性，用于在打印中心中标识打印作业,default is application name
            
            printInteraction.printInfo = printInfo;
//            printInteraction.printingItem = fileURL;
            printInteraction.showsPageRange = YES;
            printInteraction.delegate = self;

            UIViewPrintFormatter *viewFormatter = [self.wkWebView viewPrintFormatter];//直接打印webView,调起打印时间，打印效果更佳
            viewFormatter.startPage = 0;
            printInteraction.printFormatter = viewFormatter;
            
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) // ipad
            {
                [printInteraction presentFromRect:self.view.bounds inView:self.view animated:YES completionHandler:
                 ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                 {
                     if ((completed == NO) && (error != nil)){
                        NSLog(@"%s %@", __FUNCTION__, error);
                     }
                 }
                 ];
            }
            else // iphone
            {
                [printInteraction presentAnimated:YES completionHandler:
                 ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                 {
                     if ((completed == NO) && (error != nil))
                     {
                         NSLog(@"%s %@", __FUNCTION__, error);
                     }
                 }];
            }
        }
    }else{
        [MBProgressHUD zx_showError:@"This feature is not supported by the device." toView:self.view];
    }
}
- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController
{
    [MBProgressHUD zx_showLoadingWithStatus:@"正在打印..." toView:self.view];
}
- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController
{
    [MBProgressHUD zx_hideHUDForView:self.view];
}
#pragma mark 设置
-(void)makeBillSet
{
    if (self.clauseUrl) {
        [WYUTILITY  routerWithName:self.clauseUrl withSoureController:self];
    }
}
#pragma mark - Navigation
/**
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}
*/

@end
