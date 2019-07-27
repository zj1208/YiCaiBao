//
//  FastOpenShopViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "FastOpenShopViewController.h"
#import "FastOpenShopView.h"
#import "OnePickerView.h"

#import "UIViewController+XHPhoto.h"
#import "WYSelectCityView.h"
#import "WYMainCategoryViewController.h"

#import "ShopModel.h"
#import "TMDiskManager.h"
//图片上传
#import "AliOSSUploadManager.h"

#import "UIScrollView+UITouch.h"

#import "WYWriteShopNameViewController.h"

@interface FastOpenShopViewController ()<UITextFieldDelegate,WYWriteShopNameDelegate>
@property(nonatomic, strong)ShopModel *model;
@property(nonatomic, strong)NSArray *allArr;

@property (nonatomic, strong)TMDiskManager *diskManager;
//
@property (nonatomic, strong)ShopManagerInfoModel *managerInfoModel;

@property(nonatomic, copy)NSString *sysStr;
@property(nonatomic, copy)NSString *mainSellStr;
@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, strong)UserModel *userInfo;

@end

@implementation FastOpenShopViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatUI];
    [self initData];
    
    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    self.model = [[ShopModel alloc] init];
//    self.model.sellChannel = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) creatUI{
    self.title = NSLocalizedString(@"完善商铺资料", @"完善商铺资料");
    [self xm_navigationItem_titleCenter];

    FastOpenShopView *view = [[FastOpenShopView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    view.chooseMarket.yiwuDetailcell.txtfield_number.delegate = self;
    view.chooseMarket.yiwuDetailcell.txtfield_men.delegate = self;
    view.chooseMarket.yiwuDetailcell.txtfield_lou.delegate = self;
    view.chooseMarket.yiwuDetailcell.txtfield_jie.delegate = self;
    
    [view initCell];
//    view.businessPattern.RadioButton.delegate = self;
//    view.shopName.input.delegate = self;
    [view.shopName.btn_cell addTarget:self action:@selector(setShopNameTip) forControlEvents:UIControlEventTouchUpInside];
    [view.shopHeadImage.btn_cell addTarget:self action:@selector(setHeadImageTip) forControlEvents:UIControlEventTouchUpInside];
    [view.mainCategory.btn_cell addTarget:self action:@selector(setMainCategoryTip) forControlEvents:UIControlEventTouchUpInside];
    [view.chooseMarket.cell_chooseMarket.btn_cell addTarget:self action:@selector(setChooseMarketUITip) forControlEvents:UIControlEventTouchUpInside];
    [view.chooseMarket.cell_chooseDistrict.btn_cell addTarget:self action:@selector(setChooseDistrictTip) forControlEvents:UIControlEventTouchUpInside];
    [view.mainProducts.btn_cell addTarget:self action:@selector(setShopIntroTip) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_confirm addTarget:self action:@selector(fastOpenTip) forControlEvents:UIControlEventTouchUpInside];
    
    [view.businessPattern.button1 addTarget:self action:@selector(button1Tap) forControlEvents:UIControlEventTouchUpInside];
    [view.businessPattern.button2 addTarget:self action:@selector(button2Tap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskShopManageInfoKey];
    self.diskManager = manager;
    
    ShopManagerInfoModel *model = [[ShopManagerInfoModel alloc] init];
    self.managerInfoModel =model;
    [self.diskManager setData:model];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopInfoChange:) name:TMDiskShopManageInfoKey object:nil];
    
    self.allArr =[NSArray new];
    [[[AppAPIHelper shareInstance] shopAPI] getMarketsWithSuccess:^(id data) {
        self.allArr = data;
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
    
    [[[AppAPIHelper shareInstance] getUserModelAPI] getMyInfomationWithSuccess:^(id data) {
        self.userInfo = data;
        FastOpenShopView *view = (FastOpenShopView *)self.view;
//        view.name.input.text = self.userInfo.nickname;
        view.phone.input.text = self.userInfo.phone;
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)shopInfoChange:(id)notification
{
    ShopManagerInfoModel *model = (ShopManagerInfoModel *)[self.diskManager getData];
    FastOpenShopView *view = (FastOpenShopView *)self.view;
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
    self.mainSellStr = model.mainSell;
    if (sysStr.length) {
        view.mainCategory.subTitle.textColor = WYUISTYLE.colorMTblack;
        view.mainCategory.subTitle.text = sysStr;
    }else{
        view.mainCategory.subTitle.textColor = WYUISTYLE.colorBTgrey;
        view.mainCategory.subTitle.text = @"最多选择6个";
        
    }
    if (model.mainSell.length) {
        view.mainProducts.subTitle.textColor = WYUISTYLE.colorMTblack;
        view.mainProducts.subTitle.text = model.mainSell;
    }else{
        view.mainProducts.subTitle.textColor = WYUISTYLE.colorBTgrey;
        view.mainProducts.subTitle.text = @"请填写您的主营产品";
    }
}

#pragma mark -WYWriteShopNameDelegate
- (void)confirmShopName:(NSString *)name{
    FastOpenShopView *view = (FastOpenShopView *)self.view;
    self.shopName = name;
    if (name.length > 0) {
        view.shopName.subTitle.textColor = WYUISTYLE.colorMTblack;
        view.shopName.subTitle.text = name;
    }else{
        view.shopName.subTitle.textColor = WYUISTYLE.colorBTgrey;
        view.shopName.subTitle.text = @"请填写您的商铺名称";
    }
}

//填写商铺名称
- (void)setShopNameTip{
    [self.view endEditing:YES];
    WYWriteShopNameViewController  *writeShopNameVC = [[WYWriteShopNameViewController alloc]init];
    writeShopNameVC.hidesBottomBarWhenPushed = YES;
    writeShopNameVC.shopName = self.shopName;
    writeShopNameVC.delegate = self;
    [self.navigationController pushViewController:writeShopNameVC animated:YES];
    
}

-(void)setHeadImageTip{
     [self.view endEditing:YES];
    /*
     上传
     edit:照片需要裁剪:传YES,不需要裁剪传NO(默认NO)
     */
    WS(weakSelf)
    [self showCanEdit:YES photo:^(UIImage *photo) {
        if(photo){
            NSData *imageData = UIImageJPEGRepresentation(photo, 0.7);
//            [self zhHUD_showHUDAddedTo:self.view labelText:@"正在上传"];
            [[AliOSSUploadManager sharedInstance] putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_shopHeadIcon uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
                 FastOpenShopView *view = (FastOpenShopView *)weakSelf.view;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (imagePath) {
                        view.shopHeadImage.headImage.hidden = NO;
                        view.shopHeadImage.subTitle.hidden = YES;
                        weakSelf.model.iconUrl = imagePath;
                        [view.shopHeadImage.headImage sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:imagePath] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached];
                    }else{
                        view.shopHeadImage.headImage.hidden = NO;
                        view.shopHeadImage.subTitle.hidden = YES;
                    }
                });
//                [weakSelf zhHUD_hideHUDForView:weakSelf.view];
            } failure:^(NSError *error) {
                [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
            }];
        }
    }];
}

-(void)setMainCategoryTip{
     [self.view endEditing:YES];
    
    WYMainCategoryViewController *vc = [[WYMainCategoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    MainCategoryViewController *vc = [[MainCategoryViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setShopIntroTip{
     [self.view endEditing:YES];
    [self xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:@"ManageMainProController" withData:nil];
}

-(void)setChooseDistrictTip{
     [self.view endEditing:YES];
    WYSelectCityView *city = [[WYSelectCityView alloc] initSelectFrame:self.view.bounds WithTitle:@"城市"];
    [city showCityView:^(NSDictionary *provice, NSDictionary *city, NSDictionary *dis) {
        FastOpenShopView *view = (FastOpenShopView *)self.view;
        view.chooseMarket.cell_chooseDistrict.subTitle.textColor = WYUISTYLE.colorMTblack;
        if (![city objectForKey:@"name"]) {
            view.chooseMarket.cell_chooseDistrict.subTitle.text = [NSString stringWithFormat:@"%@",[provice objectForKey:@"name"]];
            self.model.province = [provice objectForKey:@"code"];
        }else if(![dis objectForKey:@"name"]){
            view.chooseMarket.cell_chooseDistrict.subTitle.text = [NSString stringWithFormat:@"%@->%@",[provice objectForKey:@"name"],[city objectForKey:@"name"]];
            self.model.province = [provice objectForKey:@"code"];
            self.model.city = [city objectForKey:@"code"];
        }else{
             view.chooseMarket.cell_chooseDistrict.subTitle.text = [NSString stringWithFormat:@"%@->%@->%@",[provice objectForKey:@"name"],[city objectForKey:@"name"],[dis objectForKey:@"name"]];
            self.model.province = [provice objectForKey:@"code"];
            self.model.city = [city objectForKey:@"code"];
            self.model.area = [dis objectForKey:@"code"];
        }
    }];
}
-(void)setChooseMarketUITip{
     [self.view endEditing:YES];
    OnePickerView *market = [[OnePickerView alloc] initWithOnePickFrame:self.view.bounds selectTitle:@"请选择您的地址"];
    market.allarr = self.allArr;
    [market showOnePickView:^(NSDictionary *marketStr) {
        FastOpenShopView *view = (FastOpenShopView *)self.view;
        marketModel *markmodel = [marketModel new];
        markmodel = (marketModel *)marketStr;
        view.marketStr = marketStr;
        view.chooseMarket.cell_chooseMarket.subTitle.textColor = WYUISTYLE.colorMTblack;
        view.chooseMarket.cell_chooseMarket.subTitle.text = markmodel.name;
        self.model.submarketCode = markmodel.code;
        self.model.submarketValue = markmodel.name;
        [view setUIChooseMarket];
    }];

    
}

-(void)fastOpenTip{
    [self.view endEditing:YES];
//    [self getShopInfo];
//    return;
    FastOpenShopView *view = (FastOpenShopView *)self.view;
    //头像YES
    //商铺名称
    self.model.name = self.shopName;
    //主营类目
    self.model.sysCates = self.sysStr;
    //主营产品
    self.model.mainSell = self.mainSellStr;
    //经营模式YES
    if (view.businessPattern.button1.selected && view.businessPattern.button2.selected) {
         self.model.sellChannel = @"3";
    }else if (view.businessPattern.button1.selected){
        self.model.sellChannel = @"0";
    }else if(view.businessPattern.button2.selected){
        self.model.sellChannel = @"2";
    }
    
    //姓名YES
    self.model.sellerName = view.name.input.text;
    //手机YES
    self.model.sellerPhone = view.phone.input.text;
    //选择市场YES
    if ([self.model.submarketCode isEqualToString:@"9999"]) {
        self.model.address = view.chooseMarket.detailAdr.text;
        self.model.door = nil;
        self.model.floor = nil;
        self.model.street = nil;
        self.model.boothNos = nil;
        
        if (!self.model.province.length){
            [MBProgressHUD zx_showError:@"请选择省市区" toView:self.view];
            return;
        }
        if (!self.model.address.length){
            [MBProgressHUD zx_showError:@"请填写详细地址" toView:self.view];
            return;
        }
    }else{
        self.model.address = nil;
        self.model.province = nil;
        self.model.city = nil;
        self.model.area = nil;
        self.model.door = view.chooseMarket.yiwuDetailcell.txtfield_men.text;
        self.model.floor = view.chooseMarket.yiwuDetailcell.txtfield_lou.text;
        self.model.street = view.chooseMarket.yiwuDetailcell.txtfield_jie.text;
        self.model.boothNos = view.chooseMarket.yiwuDetailcell.txtfield_number.text;
        if (!(self.model.floor.length && self.model.boothNos.length)) {
            [MBProgressHUD zx_showError:@"地址信息不完整" toView:self.view];
            return;
        }
    }
    
    if (!self.model.name.length){
        [MBProgressHUD zx_showError:@"请填写商铺名称" toView:self.view];
        return;
    }
    if (!self.model.sysCates.length){
        [MBProgressHUD zx_showError:@"请选择主营类目" toView:self.view];
        return;
    }
    if (!self.model.mainSell.length){
        [MBProgressHUD zx_showError:@"请输入主营产品" toView:self.view];
        return;
    }
    if (!self.model.sellChannel.length){
        [MBProgressHUD zx_showError:@"请选择主要贸易类型" toView:self.view];
        return;
    }
    if (!self.model.sellerName.length){
        [MBProgressHUD zx_showError:@"请填写商铺联系人" toView:self.view];
        return;
    }
    
    WS(weakSelf);

    
   
    [[[AppAPIHelper shareInstance] getShopAPI] postCreateShopInfoWithParameters:_model success:^(id data) {

        [_diskManager removeData];
        [weakSelf getShopInfo];
        
    } failure:^(NSError *error) {
         [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


-(void)button1Tap{
    FastOpenShopView *view = (FastOpenShopView *)self.view;
    view.businessPattern.button1.selected = !view.businessPattern.button1.selected;
}
-(void)button2Tap{
    FastOpenShopView *view = (FastOpenShopView *)self.view;
    view.businessPattern.button2.selected = !view.businessPattern.button2.selected;
}

//-(void)myRadioButtonGroup:(MyRadioButtonGroup *)radioButtonGruop clickIndex:(int)index{
//    if (index == 0) {
//        self.model.sellChannel = @"0";
//    }else{
//        self.model.sellChannel = @"2";
//    }
//}

#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    FastOpenShopView *view = (FastOpenShopView *)self.view;
//    if (textField == view.shopName.input) {
//        if (string.length == 0) return YES;
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 18) {
//            return NO;
//        }
//    }
    if (textField == view.chooseMarket.yiwuDetailcell.txtfield_number) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 30) {
            return NO;
        }
    }
    if (textField == view.chooseMarket.yiwuDetailcell.txtfield_men) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    if (textField == view.chooseMarket.yiwuDetailcell.txtfield_lou) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 2) {
            return NO;
        }
    }
    if (textField == view.chooseMarket.yiwuDetailcell.txtfield_jie) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    
    return YES;
}

-(void)getShopInfo{
    
    WS(weakSelf);
    
    [[[AppAPIHelper shareInstance] getShopAPI] getMyShopIdsWithSuccess:^(id data) {

        [UserInfoUDManager setShopId:data];
        
        //有可能是路由从接生意首页跳转到开店引导
        if(_soureControllerType ==SourceControllerType_OpenShopGuide)
        {
            UITabBarController *tabController = (UITabBarController *)APP_MainWindow.rootViewController;
            UINavigationController *selectedNav = tabController.selectedViewController;
            if ([selectedNav.topViewController isKindOfClass:NSClassFromString(@"FastOpenShopViewController")])
            {
                [selectedNav popToRootViewControllerAnimated:NO];
            }
            tabController.selectedIndex = 1;
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }

    
    } failure:^(NSError *error) {
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
@end
