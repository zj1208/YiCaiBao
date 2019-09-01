//
//  WYPerfectStoreInfoViewController.m
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYPerfectShopInfoViewController.h"
#import "OpenShopBaseTableViewCell.h"
#import "OpenShopInputTableViewCell.h"
#import "OSTradeTypeTableViewCell.h"
#import "OSYiWuAddressTableViewCell.h"
#import "OSAddressTableViewCell.h"
#import "OpenShopSaveTableViewCell.h"
#import "TMDiskManager.h"
//图片上传
#import "AliOSSUploadManager.h"
#import "UIViewController+XHPhoto.h"
#import "WYSelectCityView.h"
#import "OnePickerView.h"

#import "WYWriteShopNameViewController.h"
#import "WYMainCategoryViewController.h"

@interface WYPerfectShopInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WYWriteShopNameDelegate,OSTradeTypeTableViewCellDelegate,OSYiWuAddressTableViewCellDelegate,OSAddressTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ShopModel *model;
@property (nonatomic, strong) TMDiskManager *diskManager;
@property (nonatomic, strong) ShopManagerInfoModel *managerInfoModel;
@property (nonatomic, strong) UserModel *userInfo;

@property (nonatomic, strong) NSArray *allArr;

@property (nonatomic, copy) NSString *sysCode;//主营类目
@property (nonatomic, copy) NSString *sysStr;
@property (nonatomic, copy) NSString *mainSellStr;//主营产品
@property (nonatomic, copy) NSString *shopName;//商铺名称
@property (nonatomic, copy) NSString *address;//

@property (nonatomic) BOOL isMenLou;//义乌市场展示门楼街

@property (nonatomic, weak) UITextField *nameTextField;
@property (nonatomic, weak) UITextField *phoneTextField;
@end

@implementation WYPerfectShopInfoViewController

#pragma mark ------LifeCirle------

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"完善商铺资料", @"完善商铺资料");
    [self creatUI];
    
    //初始化oss上传
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    self.model = [[ShopModel alloc] init];
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskShopManageInfoKey];
    self.diskManager = manager;
    
    ShopManagerInfoModel *model = [[ShopManagerInfoModel alloc] init];
    self.managerInfoModel =model;
    [self.diskManager setData:model];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopInfoChange:) name:TMDiskShopManageInfoKey object:nil];
    
    [self requestMyInfo];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------Action------
//设置商铺头像
- (void)setHeadImageAction{
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
                //                FastOpenShopView *view = (FastOpenShopView *)weakSelf.view;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (imagePath) {
                        weakSelf.model.iconUrl = imagePath;
                        [weakSelf.tableView reloadData];
                    }
                });
            } failure:^(NSError *error) {
                [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
            }];
        }
    }];
}

//设置商铺名称
- (void)setShopNameAction{
    WYWriteShopNameViewController  *writeShopNameVC = [[WYWriteShopNameViewController alloc]init];
    writeShopNameVC.hidesBottomBarWhenPushed = YES;
    writeShopNameVC.shopName = self.shopName;
    writeShopNameVC.delegate = self;
    [self.navigationController pushViewController:writeShopNameVC animated:YES];
}

//设置主营类目
-(void)setMainCategoryAction{
    WYMainCategoryViewController *vc = [[WYMainCategoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//设置主营产品
-(void)setMainProductAction{
    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:@"ManageMainProController" withData:nil];
}

//选择所在区域
-(void)chooseDistrictAction{
    WYSelectCityView *city = [[WYSelectCityView alloc] initSelectFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) WithTitle:@"城市"];
    WS(weakSelf)
    [city showCityView:^(NSDictionary *provice, NSDictionary *city, NSDictionary *dis){
        if (![city objectForKey:@"name"]) {
            weakSelf.address = [NSString stringWithFormat:@"%@",[provice objectForKey:@"name"]];
            weakSelf.model.province = [provice objectForKey:@"code"];
        }else if(![dis objectForKey:@"name"]){
            weakSelf.address = [NSString stringWithFormat:@"%@->%@",[provice objectForKey:@"name"],[city objectForKey:@"name"]];
            weakSelf.model.province = [provice objectForKey:@"code"];
            weakSelf.model.city = [city objectForKey:@"code"];
        }else{
            weakSelf.address = [NSString stringWithFormat:@"%@->%@->%@",[provice objectForKey:@"name"],[city objectForKey:@"name"],[dis objectForKey:@"name"]];
            weakSelf.model.province = [provice objectForKey:@"code"];
            weakSelf.model.city = [city objectForKey:@"code"];
            weakSelf.model.area = [dis objectForKey:@"code"];
        }
        
        [weakSelf cleanMarketInfo];
        
        [weakSelf requestMarket];
    }];
}
//选择市场
-(void)chooseMarketAction{
    WS(weakSelf)
    OnePickerView *market = [[OnePickerView alloc] initWithOnePickFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) selectTitle:@"请选择您的地址"];
    market.allarr = self.allArr;
    [market showOnePickView:^(NSDictionary *marketStr) {
        marketModel *markmodel = [marketModel new];
        markmodel = (marketModel *)marketStr;
        //        view.marketStr = marketStr;
        //        view.chooseMarket.cell_chooseMarket.subTitle.textColor = WYUISTYLE.colorMTblack;
        //        view.chooseMarket.cell_chooseMarket.subTitle.text = markmodel.name;
        weakSelf.model.marketId = markmodel.marketId;
        weakSelf.model.submarketCode = markmodel.code;
        weakSelf.model.submarketValue = markmodel.name;
        weakSelf.isMenLou = [markmodel.kind isEqualToString:@"2"];
        
        [weakSelf cleanAddressInfo];
        
        [weakSelf.tableView reloadData];
        //        [view setUIChooseMarket];
    }];
    
    
}

-(void)fastOpenAction{
    [self.view endEditing:YES];
    //头像YES
    //商铺名称
    self.model.name = self.shopName;
    //主营类目
    self.model.sysCates = self.sysCode;
    //主营产品
    self.model.mainSell = self.mainSellStr;
    
    
    //姓名YES
    self.model.sellerName = self.nameTextField.text;
    //手机YES
    self.model.sellerPhone = self.phoneTextField.text;
    
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
    if (!self.model.province.length){
        [MBProgressHUD zx_showError:@"请选择您的所在区域" toView:self.view];
        return;
    }
    if (self.isMenLou){
        if (!(self.model.door.length && self.model.floor.length && self.model.street.length && self.model.boothNos.length)) {
            [MBProgressHUD zx_showError:@"请补充您的详细地址" toView:self.view];
            return;
        }
    }else{
        if (!self.model.address.length){
            [MBProgressHUD zx_showError:@"请补充您的详细地址" toView:self.view];
            return;
        }
    }
    if (!self.model.sellerName.length){
        [MBProgressHUD zx_showError:@"请填写商铺联系人" toView:self.view];
        return;
    }
    [self requestOpenShop];
    
}

//开店后处理
-(void)getShopInfo{
    
    WS(weakSelf);
    
    [[[AppAPIHelper shareInstance] getShopAPI] getMyShopIdsWithSuccess:^(id data) {
        
        [UserInfoUDManager setShopId:data];
        
        //有可能是路由从接生意首页跳转到开店引导
        if(_soureControllerType ==SourceControllerType_OpenShopGuide)
        {
            UITabBarController *tabController = (UITabBarController *)APP_MainWindow.rootViewController;
            UINavigationController *selectedNav = tabController.selectedViewController;
            if ([selectedNav.topViewController isKindOfClass:NSClassFromString(@"WYPerfectShopInfoViewController")])
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


#pragma mark ------Request------
- (void)requestMarket{
    WS(weakSelf)
    self.allArr =[NSArray new];
    [[[AppAPIHelper shareInstance] shopAPI] getMarketsByCity:self.model.city success:^(id data) {
        weakSelf.allArr = data;
        if (weakSelf.allArr.count == 0) {
            weakSelf.model.submarketValue = @"其他";
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestMyInfo{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getUserModelAPI] getMyInfomationWithSuccess:^(id data) {
        weakSelf.userInfo = data;
        weakSelf.model.sellerPhone = weakSelf.userInfo.phone;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

//开店
- (void)requestOpenShop{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getShopAPI] postCreateShopInfoWithParameters:_model success:^(id data) {
        
        [_diskManager removeData];
        [weakSelf getShopInfo];
        
    } failure:^(NSError *error) {
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark ------NSNotificationCenter------

- (void)shopInfoChange:(id)notification{
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
    self.sysCode = sysCodeStr;
    self.sysStr = sysStr;
    self.mainSellStr = model.mainSell;
    [self.tableView reloadData];
    
}
#pragma mark ------WYWriteShopNameDelegate------
- (void)confirmShopName:(NSString *)name{
    self.shopName = name;
    [self.tableView reloadData];
}

#pragma mark ------OSTradeTypeTableViewCellDelegate------
- (void)tradeType:(NSInteger)type{
    if (type & TradeTypeDomestic && type & TradeTypeForeign) {
        self.model.sellChannel = @"3";
    }else if (type & TradeTypeDomestic){
        self.model.sellChannel = @"0";
    }else if (type & TradeTypeForeign){
        self.model.sellChannel = @"2";
    }else{
        self.model.sellChannel = @"";
    }
}

#pragma mark ------OSYiWuAddressTableViewCellDelegate------
- (void)addressMenString:(NSString *)men louString:(NSString *)lou jieString:(NSString *)jie shopNumberString:(NSString *)shopNumber{
    self.model.door = men;
    self.model.floor = lou;
    self.model.street = jie;
    self.model.boothNos = shopNumber;
    self.model.address = nil;
}

#pragma mark ------OSAddressTableViewCellDelegate------
- (void)addressDetail:(NSString *)address{
    self.model.address = address;
    self.model.door = nil;
    self.model.floor = nil;
    self.model.street = nil;
    self.model.boothNos = nil;
}

#pragma mark ------UITextFieldDelegate------
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.nameTextField) {
        self.model.sellerName = textField.text;
    }else if (textField == self.phoneTextField){
        self.model.sellerPhone = textField.text;
    }
}

#pragma mark ------UITableviewDatasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }else if (section == 1) {
        return 3;
    }else if (section == 2) {
        return 2;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 4) {
        OSTradeTypeTableViewCell *cell = (OSTradeTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OSTradeTypeTableViewCellID forIndexPath:indexPath];
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 2){
        if (self.isMenLou){
            OSYiWuAddressTableViewCell *cell = (OSYiWuAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OSYiWuAddressTableViewCellID forIndexPath:indexPath];
            [cell updateMen:self.model.door lou:self.model.floor jie:self.model.street shopNumber:self.model.boothNos];
            cell.delegate = self;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else{
            OSAddressTableViewCell *cell = (OSAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OSAddressTableViewCellID forIndexPath:indexPath];
            cell.addressTextField.text = self.model.address;
            cell.delegate = self;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        OpenShopInputTableViewCell *cell = (OpenShopInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OpenShopInputTableViewCellID forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateTitle:NSLocalizedString(@"商铺联系人", @"") content:self.model.sellerName placeholder:NSLocalizedString(@"请输入姓名", @"")];
        self.nameTextField = cell.textField;
        cell.textField.delegate = self;
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        OpenShopInputTableViewCell *cell = (OpenShopInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OpenShopInputTableViewCellID forIndexPath:indexPath];
        [cell updateTitle:NSLocalizedString(@"手机", @"") content:self.model.sellerPhone placeholder:NSLocalizedString(@"请输入手机号", @"")];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.phoneTextField = cell.textField;
        cell.textField.delegate = self;
        return cell;
    }else if (indexPath.section == 3) {
        OpenShopSaveTableViewCell *cell = (OpenShopSaveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OpenShopSaveTableViewCellID forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.saveButton addTarget:self action:@selector(fastOpenAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        OpenShopBaseTableViewCell *cell = (OpenShopBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OpenShopBaseTableViewCellID forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.section == 0 && indexPath.row == 0) {
            [cell updateTitle:NSLocalizedString(@"商铺头像", @"") content:@"" placeholder:NSLocalizedString(@"请选择头像", @"")];
            [cell updateImageWithUrl:self.model.iconUrl];
        }else if (indexPath.section == 0 && indexPath.row == 1){
            [cell updateTitle:NSLocalizedString(@"商铺名称", @"") content:self.shopName placeholder:NSLocalizedString(@"请填写您的商铺名称", @"")];
        }else if (indexPath.section == 0 && indexPath.row == 2){
            [cell updateTitle:NSLocalizedString(@"主营类目", @"") content:self.sysStr placeholder:NSLocalizedString(@"最多选择6个", @"")];
        }else if (indexPath.section == 0 && indexPath.row == 3){
            [cell updateTitle:NSLocalizedString(@"主营产品", @"") content:self.mainSellStr placeholder:NSLocalizedString(@"请填写您的主营产品", @"")];
        }else if (indexPath.section == 1 && indexPath.row == 0){
            [cell updateTitle:NSLocalizedString(@"所在区域", @"") content:self.address placeholder:NSLocalizedString(@"请选择您所在的城市", @"")];
        }else if (indexPath.section == 1 && indexPath.row == 1){
            [cell updateTitle:NSLocalizedString(@"所属市场", @"") content:self.model.submarketValue placeholder:NSLocalizedString(@"请选择市场", @"")];
        }
        return cell;
    }
    
}

#pragma mark ------UITableViewDelegate------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 140.0;
    }else if (indexPath.section == 1 && indexPath.row == 2 && self.isMenLou){
        return 90.0;
    }
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0 && indexPath.row == 0){
        [self setHeadImageAction];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [self setShopNameAction];
    }else if (indexPath.section == 0 && indexPath.row == 2){
        [self setMainCategoryAction];
    }else if (indexPath.section == 0 && indexPath.row == 3){
        [self setMainProductAction];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        [self chooseDistrictAction];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        if (self.model.province.length == 0){
            [MBProgressHUD zx_showError:NSLocalizedString(@"请先选择所在区域", @"") toView:self.view];
        }else if (self.allArr.count <= 0) {
            [MBProgressHUD zx_showError:NSLocalizedString(@"该区域暂无市场可选", @"") toView:self.view];
        }else{
            [self chooseMarketAction];
        }
    }
}

#pragma mark ------PrivateAndUI------
- (void)creatUI{
    _tableView = [[UITableView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    
    [_tableView registerNib:[UINib nibWithNibName:@"OpenShopBaseTableViewCell" bundle:nil] forCellReuseIdentifier:OpenShopBaseTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"OpenShopInputTableViewCell" bundle:nil] forCellReuseIdentifier:OpenShopInputTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"OSTradeTypeTableViewCell" bundle:nil] forCellReuseIdentifier:OSTradeTypeTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"OSYiWuAddressTableViewCell" bundle:nil] forCellReuseIdentifier:OSYiWuAddressTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"OSAddressTableViewCell" bundle:nil] forCellReuseIdentifier:OSAddressTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"OpenShopSaveTableViewCell" bundle:nil] forCellReuseIdentifier:OpenShopSaveTableViewCellID];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

//清楚填写的详细地址
- (void)cleanAddressInfo{
    self.model.address = nil;
    self.model.door = nil;
    self.model.floor = nil;
    self.model.street = nil;
    self.model.boothNos = nil;
}

//清除选择市场相关信息
- (void)cleanMarketInfo{
    self.model.marketId = nil;
    self.model.submarketCode = nil;
    self.model.submarketValue = nil;
    self.isMenLou = NO;
    
    [self cleanAddressInfo];
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
