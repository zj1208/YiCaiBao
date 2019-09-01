//
//  WYTradeSetViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYTradeSetViewController.h"
#import "ShopModel.h"
#import "WYMainCategoryViewController.h"
#import "TMDiskManager.h"

#import "MessageModel.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface WYTradeSetViewController ()<ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)UIButton* saveBtn;

@property (nonatomic, strong)TMDiskManager *diskManager;
@property (nonatomic, strong)ShopManagerInfoModel *managerInfoModel;
@property(nonatomic, copy)NSString *sysStr;//id,拼接

@property(nonatomic, assign)BOOL ischangShopInfo;//是否改动，未改动返回不弹出提示框
@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@property (nonatomic, copy) NSString *ruleUrl;//规则URL

@end
static NSInteger const numWords = 200;
@implementation WYTradeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.contentView.hidden = YES;
    [self setUI];
    [self clickNoti]; //检查通知是否启用,开启后返回刷新
    
    [self initShopCategoryInfoData];

    //请求数据
    [self initOrderRomSet];

    [self addNoti];
}
//生意语音开关
- (IBAction)messageSwitch:(UISwitch *)sender {
    [self  setTuiSongData];
}
//库存推送开关
- (IBAction)stockSwitch:(UISwitch *)sender {
    [self setOrderRomSet];
}

-(void)addNoti
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopInfoChange:) name:TMDiskShopManageInfoKey object:nil];
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickNoti) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)shopInfoChange:(id)notification
{
    self.ischangShopInfo = YES; //点了确定视为改动了，只是用于返回是否显示弹框

    ShopManagerInfoModel *model = (ShopManagerInfoModel *)[self.diskManager getData];
    
    NSMutableArray *sysArr = [NSMutableArray array];
    NSMutableArray *syscodeArr = [NSMutableArray array];
    for (SysCateModel *dic in model.sysCates) {
        [sysArr addObject:dic.n];
    }
    NSString *sysStr = [sysArr componentsJoinedByString:@","];
    for (SysCateModel *dic in model.sysCates) {
        [syscodeArr addObject:dic.v];
    }
    NSString *sysCodeStr = [syscodeArr componentsJoinedByString:@","];
    self.sysStr = sysCodeStr;

    if (sysStr.length) {
        
        self.classHadSelectedLabel.textColor = [WYUISTYLE colorWithHexString:@"222222"];
        self.classHadSelectedLabel.text = sysStr;
        
    }else{
        self.classHadSelectedLabel.textColor = [WYUISTYLE colorWithHexString:@"cccccc"];
        self.classHadSelectedLabel.text = @"选择您的主营类目";
    }

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.diskManager removeData];
}
#pragma mark - 保存数据
-(void)saveData
{
    if ([NSString zhIsBlankString:self.classHadSelectedLabel.text]) {
        [MBProgressHUD zx_showError:@"选择您的主营类目" toView:self.view];
        return;
    }
    NSString* strmainSellStr = self.zxTextView.text;
    if ([NSString zhIsBlankString:strmainSellStr]) {
        [MBProgressHUD zx_showError:@"请输入您商铺内主营产品的名称，用逗号隔开，例：玻璃水杯，玻璃花瓶，茶具，酒壶..." toView:self.view];
        return;
    }
    
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    
    [[[AppAPIHelper shareInstance]shopAPI] postShopStoreMfyShopMgr4orderWithSysCates:self.sysStr mainSell:strmainSellStr success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:nil];

        [self.navigationController popViewControllerAnimated:NO];
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
#pragma mark - 请求商户经营信息数据
-(void)initShopInfoData
{
    [[[AppAPIHelper shareInstance]shopAPI] getShopManagerInfoWithshopId:nil success:^(id data) {
     
        [MBProgressHUD zx_hideHUDForView:self.view];

        self.managerInfoModel = (ShopManagerInfoModel*)data;
        [self.diskManager setData:self.managerInfoModel];
        
        self.contentView.hidden = NO;
        [self upddatUI];
        
        if (self.managerInfoModel) {
            [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:self.view];
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:[error localizedDescription] updateBtnHide:YES];
    }];
}
#pragma mark - 接生意声音推送初始化
-(void)initTuiSongData
{
    [[[AppAPIHelper shareInstance] getMessageAPI] querySoundSettingWithSuccess:^(id data) {
       
        SoundModel *soundModel = (SoundModel *)data;
        _messageSwitch.on = soundModel.enableSubject.boolValue;
        [[NSUserDefaults standardUserDefaults] setObject:soundModel.enableSubject forKey:EnableSubject];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self initShopInfoData];

    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:self.view];
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:[error localizedDescription] updateBtnHide:YES];
    }];
}
#pragma mark - 接生意声音推送设置
-(void)setTuiSongData
{
    _messageSwitch.enabled = NO;
    [[[AppAPIHelper shareInstance] getMessageAPI] updateSoundSettingWithSubject:[NSString stringWithFormat:@"%d",_messageSwitch.on] fan:nil visitor:nil success:^(id data) {
       
        _messageSwitch.enabled = YES;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_messageSwitch.on] forKey:EnableSubject];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } failure:^(NSError *error) {
        _messageSwitch.enabled = YES;
        _messageSwitch.on = !_messageSwitch.on; //
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}

#pragma mark - 是否接收其他求购初始化
-(void)initOrderRomSet
{
    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];

    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getTradeMainAPI] getkTradeMtopOrderRomQueryURLsuccess:^(id data) {
        NSNumber* bo = [data objectForKey:@"rom"] ;
        _stockSwitch.on = bo.boolValue;
        weakSelf.ruleUrl = [data objectForKey:@"bidSettingIntroUrl"] ;
        [self initTuiSongData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:self.view];
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:[error localizedDescription] updateBtnHide:YES];
    }];
}
#pragma mark - 设置是否接收其他求购
-(void)setOrderRomSet
{
    _stockSwitch.enabled = NO;
    [[[AppAPIHelper shareInstance] getTradeMainAPI] postMtopOrderRomSetURLWithRom:_stockSwitch.on success:^(id data) {
        _stockSwitch.enabled = YES;
    } failure:^(NSError *error) {
        _stockSwitch.enabled = YES;
        _stockSwitch.on = !_stockSwitch.on; //
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
//不用啦
-(void)zxEmptyViewUpdateAction
{
//    [self initOrderRomSet];
}
- (void)initShopCategoryInfoData{
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskShopManageInfoKey];
    self.diskManager = manager;
    
    ShopManagerInfoModel *model = [[ShopManagerInfoModel alloc] init];
    self.managerInfoModel =model;
    [self.diskManager setData:model];
}
#pragma mark - 检查本地通知是否开启
- (void)clickNoti
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus ==UNAuthorizationStatusDenied) //未设置
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.notiContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(90.f);
                    }];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.notiContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(0);
                    }];
                });
                
            }
        }];
    }
    else
    {
        UIUserNotificationSettings * notiSettings = [[UIApplication sharedApplication]currentUserNotificationSettings];
        if (notiSettings.types == UIUserNotificationTypeNone)//未设置
        {
            [self.notiContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(90.f);
            }];

        }else{
            [self.notiContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
    }
}
#pragma mark - Action
//选择类目
- (IBAction)selectClassPushBTnClick:(UIButton *)sender {
    WYMainCategoryViewController *vc = [[WYMainCategoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//去开启
- (IBAction)goToOpenNotiBtnClick:(UIButton *)sender {
    [MobClick event:kUM_b_indexsetpush];

    NSURL *openUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
    {
        [[UIApplication sharedApplication] openURL:openUrl options:@{} completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:openUrl];
    }
    
}
//如何让生意推送更精准，查看生意推送规则 》
- (IBAction)lookTradeRulesBtnClick:(UIButton *)sender{
    if (self.ruleUrl.length){
//    NSString *urlStr = [NSString stringWithFormat:@"%@/ycbx/page/pushRule.html",[WYUserDefaultManager getkAPP_H5URL]];
        [WYUTILITY routerWithName:self.ruleUrl withSoureController:self];
    }
}

-(void)setUI
{
    [self.notiContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [self.view layoutIfNeeded];
    
    self.gotoOpenBtn.layer.masksToBounds = YES;
    self.gotoOpenBtn.layer.cornerRadius = self.gotoOpenBtn.frame.size.height/2;
    UIImage* image = [WYUISTYLE imageWithStartColorHexString:@"#FE4D37" EndColorHexString:@"#FD7953" WithSize:self.gotoOpenBtn.frame.size];
    [self.gotoOpenBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    self.textViewContentView.layer.masksToBounds = YES;
    self.textViewContentView.layer.cornerRadius = 2.f;
    self.textViewContentView.layer.borderWidth = 0.5f;
    self.textViewContentView.layer.borderColor = [WYUISTYLE colorWithHexString:@"E1E1E1"].CGColor;

    self.zxTextView.placeholder = @"请输入您商铺内主营产品的名称，用逗号隔开，例：玻璃水杯，玻璃花瓶，茶具，酒壶...";
    self.zxTextView.tintColor = [UIColor darkGrayColor];
    
    WS(weakSelf);
    [self.zxTextView setMaxCharacters:numWords textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
        weakSelf.numWordsOfcountLabel.text = [NSString stringWithFormat:@"(%ld/%ld)",(numWords-remainCount),numWords];
    }];
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
    self.emptyViewController.view.frame = self.view.frame;
    self.emptyViewController.delegate = self;

}
#pragma mark - 更新UI数据
-(void)upddatUI
{
    [self NavigationBarSet];

    NSMutableArray* arrayClass = [NSMutableArray array];
    if (self.managerInfoModel) {
        for (int i=0; i<self.managerInfoModel.sysCates.count; ++i) {
            SysCateModel* model = self.managerInfoModel.sysCates[i];
            [arrayClass addObject:model.n];
        }
    }
    NSString* classStr = [arrayClass componentsJoinedByString:@","];
    self.classHadSelectedLabel.text = classStr;
    self.classHadSelectedLabel.textColor = [WYUISTYLE colorWithHexString:@"222222"];

    NSMutableArray* syscodeArr = [NSMutableArray array];
    for (SysCateModel *dic in self.managerInfoModel.sysCates) {
        [syscodeArr addObject:dic.v];
    }
    NSString *sysCodeStr = [syscodeArr componentsJoinedByString:@","];
    self.sysStr = sysCodeStr;
    
    if (self.managerInfoModel.mainSell) {
        self.zxTextView.text = self.managerInfoModel.mainSell;
    }
}
#pragma mark - 导航栏设置
-(void)NavigationBarSet
{
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 22)];
    [self.saveBtn setImage:[UIImage imageNamed:@"btn_save"] forState:UIControlStateNormal];
    [self.saveBtn setAdjustsImageWhenHighlighted:NO];
    [self.saveBtn addTarget:self action:@selector(clickSaveBarbutton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    
    if (LCDW >375.f) {  //单独处理plus自动偏移间距（plus多5.f）
        self.navigationItem.rightBarButtonItems = [self zx_navigationItem_leftOrRightItemReducedSpaceToMagin:-7.f withItems:@[rightBarButtonItem]];
    }else{
        self.navigationItem.rightBarButtonItems = [self zx_navigationItem_leftOrRightItemReducedSpaceToMagin:-2.f withItems:@[rightBarButtonItem]];
    }

}
#pragma mark - 保存
-(void)clickSaveBarbutton:(UIButton*)sender
{
    [self saveData];
}

#pragma mark 拦截系统返回按钮事件
- (BOOL)navigationShouldPopOnBackButton
{
    [self.view endEditing:YES];
    if (_managerInfoModel.mainSell &&! [self.managerInfoModel.mainSell isEqualToString:self.zxTextView.text]) {
        self.ischangShopInfo = YES;
    }
    
    if (self.ischangShopInfo) {
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"提示" message:@"是否保存更改后内容" cancelButtonTitle:@"不保存" cancleHandler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        } doButtonTitle:@"保存" doHandler:^(UIAlertAction * _Nonnull action) {
            
            [self clickSaveBarbutton:self.saveBtn];
        }];
        return NO;
    }else{
        return YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
