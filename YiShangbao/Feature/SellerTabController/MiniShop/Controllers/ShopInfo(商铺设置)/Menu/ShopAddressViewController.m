//
//  ShopAddressViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopAddressViewController.h"
#import "OpenShopBaseTableViewCell.h"
#import "OSYiWuAddressTableViewCell.h"
#import "OSAddressTableViewCell.h"

//#import "ShopAddressView.h"

#import "WYSelectCityView.h"
#import "OnePickerView.h"

#import "ShopModel.h"

@interface ShopAddressViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,OSYiWuAddressTableViewCellDelegate,OSAddressTableViewCellDelegate>
@property(nonatomic, strong)NSArray *allArr;
@property(nonatomic, strong)ShopAddrModel *addrModel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *address;//
@property (nonatomic) BOOL isMenLou;//义乌门楼地址

@end

@implementation ShopAddressViewController

#pragma mark ------LifeCircle------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"商铺地址", @"");

    [self creatUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    [self requestAddressInfo];
}

#pragma mark ------Action------

-(void)rightBtnAction{
    [self.view endEditing:YES];
    if (!self.addrModel.pro.length){
        [MBProgressHUD zx_showError:@"请选择您的所在区域" toView:self.view];
        return;
    }
    if (self.isMenLou){
        if (!(self.addrModel.door.length && self.addrModel.floor.length && self.addrModel.booth.length && self.addrModel.booth)) {
            [MBProgressHUD zx_showError:@"请补充您的详细地址" toView:self.view];
            return;
        }
    }else{
        if (!self.addrModel.addr.length){
            [MBProgressHUD zx_showError:@"请补充您的详细地址" toView:self.view];
            return;
        }
    }
    [self requestSetAddress];
}

//选择所在区域
-(void)setChooseDistrictTip{
    WS(weakSelf)
    [self.view endEditing:YES];
    WYSelectCityView *city = [[WYSelectCityView alloc] initSelectFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) WithTitle:@"城市"];
    [city showCityView:^(NSDictionary *provice, NSDictionary *city, NSDictionary *dis) {
        if (![city objectForKey:@"name"]) {
            weakSelf.address = [NSString stringWithFormat:@"%@",[provice objectForKey:@"name"]];
            weakSelf.addrModel.pro = [provice objectForKey:@"code"];
            weakSelf.addrModel.city = @"";
            weakSelf.addrModel.area = @"";
        }else if(![dis objectForKey:@"name"]){
            weakSelf.address = [NSString stringWithFormat:@"%@->%@",[provice objectForKey:@"name"],[city objectForKey:@"name"]];
            weakSelf.addrModel.pro = [provice objectForKey:@"code"];
            weakSelf.addrModel.city = [city objectForKey:@"code"];
            weakSelf.addrModel.area = @"";
        }else{
            weakSelf.address = [NSString stringWithFormat:@"%@->%@->%@",[provice objectForKey:@"name"],[city objectForKey:@"name"],[dis objectForKey:@"name"]];
            weakSelf.addrModel.pro = [provice objectForKey:@"code"];
            weakSelf.addrModel.city = [city objectForKey:@"code"];
            weakSelf.addrModel.area = [dis objectForKey:@"code"];
        }
        //清空相关数据
        self.isMenLou = NO;
        self.addrModel.submarket = nil;
        self.addrModel.submarketValue = nil;
        self.addrModel.marketId = nil;
        self.addrModel.door = nil;
        self.addrModel.floor = nil;
        self.addrModel.street = nil;
        self.addrModel.booth = nil;
        self.addrModel.addr = nil;
        [weakSelf requestMarket];
        [weakSelf.tableView reloadData];
    }];
}
//选择市场
-(void)setChooseMarketUITip{
    WS(weakSelf)
     [self.view endEditing:YES];
    OnePickerView *market = [[OnePickerView alloc] initWithOnePickFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) selectTitle:@"选择市场"];
    market.allarr = self.allArr;
    [market showOnePickView:^(NSDictionary *marketStr) {
        marketModel *markmodel = [marketModel new];
        markmodel = (marketModel *)marketStr;
        weakSelf.addrModel.submarket = markmodel.code;
        weakSelf.addrModel.submarketValue = markmodel.name;
        weakSelf.addrModel.marketId = markmodel.marketId;
        weakSelf.isMenLou = [markmodel.kind isEqualToString:@"2"];
        //清空相关数据
        weakSelf.addrModel.door = nil;
        weakSelf.addrModel.floor = nil;
        weakSelf.addrModel.street = nil;
        weakSelf.addrModel.booth = nil;
        weakSelf.addrModel.addr = nil;
        
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark ------Request------
//获取市场信息
- (void)requestMarket{
    WS(weakSelf)
    self.allArr =[NSArray new];
    [[[AppAPIHelper shareInstance] shopAPI] getMarketsByCity:self.addrModel.city success:^(id data) {
        weakSelf.allArr = data;
        if (weakSelf.allArr.count == 0) {
            weakSelf.addrModel.submarketValue = @"其他";
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

//获取地址信息
- (void)requestAddressInfo{
    WS(weakSelf)
    self.addrModel = [[ShopAddrModel alloc] init];
    [[[AppAPIHelper shareInstance] shopAPI] getShopArrdNewWithsuccess:^(id data) {
        weakSelf.addrModel = data;
        weakSelf.isMenLou = [weakSelf.addrModel.kind isEqualToString:@"2"];
        weakSelf.address = [NSString stringWithFormat:@"%@",weakSelf.addrModel.proVO];
        if (weakSelf.addrModel.cityVO.length > 0) {
            weakSelf.address = [NSString stringWithFormat:@"%@->%@",weakSelf.address,weakSelf.addrModel.cityVO];
        }
        if (weakSelf.addrModel.areaVO.length > 0) {
           weakSelf.address = [NSString stringWithFormat:@"%@->%@",weakSelf.address,weakSelf.addrModel.areaVO];
        }
        [weakSelf requestMarket];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

//修改地址
- (void)requestSetAddress{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] shopAPI] postModifyShopArrdWithParameters:self.addrModel success:^(id data) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark ------OSYiWuAddressTableViewCellDelegate------
- (void)addressMenString:(NSString *)men louString:(NSString *)lou jieString:(NSString *)jie shopNumberString:(NSString *)shopNumber{
    self.addrModel.door = men;
    self.addrModel.floor = lou;
    self.addrModel.street = jie;
    self.addrModel.booth = shopNumber;
}

#pragma mark ------OSAddressTableViewCellDelegate------
- (void)addressDetail:(NSString *)address{
    self.addrModel.addr = address;
}

#pragma mark ------UITableviewDatasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        OpenShopBaseTableViewCell *cell = (OpenShopBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OpenShopBaseTableViewCellID forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell updateTitle:NSLocalizedString(@"所在区域", @"") content:self.address placeholder:NSLocalizedString(@"请选择您所在的城市", @"")];
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        OpenShopBaseTableViewCell *cell = (OpenShopBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OpenShopBaseTableViewCellID forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell updateTitle:NSLocalizedString(@"所属市场", @"") content:self.addrModel.submarketValue placeholder:NSLocalizedString(@"请选择市场", @"")];
        return cell;
    }else{
        if (self.isMenLou){
            OSYiWuAddressTableViewCell *cell = (OSYiWuAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OSYiWuAddressTableViewCellID forIndexPath:indexPath];
            cell.delegate = self;
            [cell updateMen:self.addrModel.door lou:self.addrModel.floor jie:self.addrModel.street shopNumber:self.addrModel.booth];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else{
            OSAddressTableViewCell *cell = (OSAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:OSAddressTableViewCellID forIndexPath:indexPath];
            cell.delegate = self;
            cell.addressTextField.text = self.addrModel.addr;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
    
}

#pragma mark ------UITableViewDelegate------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2 && self.isMenLou){
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
        [self setChooseDistrictTip];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        if (self.addrModel.pro.length == 0){
            [MBProgressHUD zx_showError:NSLocalizedString(@"请先选择所在区域", @"") toView:self.view];
        }else if (self.allArr.count <= 0) {
            [MBProgressHUD zx_showError:NSLocalizedString(@"该区域暂无市场可选", @"") toView:self.view];
        }else{
            [self setChooseMarketUITip];
        }
    }
}

#pragma mark ------UIAndPrivate------

-(void)creatUI{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:NSLocalizedString(@"保存", @"保存") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHex:0XFF5434] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    rightBtn.frame = CGRectMake(0, 0, 52, 22);
    rightBtn.layer.borderColor = [UIColor colorWithHex:0xFF5434].CGColor;
    rightBtn.layer.borderWidth = 0.5;
    rightBtn.layer.cornerRadius = 14.0;
    rightBtn.layer.masksToBounds= YES;
//    [rightBtn sizeToFit];
//    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    UIBarButtonItem *BtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem  = BtnItem;
    
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
    [_tableView registerNib:[UINib nibWithNibName:@"OSYiWuAddressTableViewCell" bundle:nil] forCellReuseIdentifier:OSYiWuAddressTableViewCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"OSAddressTableViewCell" bundle:nil] forCellReuseIdentifier:OSAddressTableViewCellID];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


@end
