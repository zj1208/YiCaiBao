//
//  WYShopInfoViewController.m
//  YiShangbao
//
//  Created by light on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "ShopInfoTableViewCell.h"
#import "ShopFunctionTableViewCell.h"
#import "ShopInfoBaseTableViewCell.h"
#import "ShopInfoOtherTableViewCell.h"
#import "ShopModel.h"

#import "ContactViewController.h"
#import "BankAccountViewController.h"
#import "ShopSceneryViewController.h"

@interface ShopInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ShopInfoModel *shopInfoModel;

@end

@implementation ShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商铺资料设置";
    
    [self setUI];
    self.shopInfoModel = [[ShopInfoModel alloc]init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self shopInfoRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Action

//预览商铺
- (void)shopButtonAction{
    if (self.shopInfoModel.shopPreUrl) {
        NSString *url = [self.shopInfoModel.shopPreUrl stringByReplacingOccurrencesOfString:@"{shopId}" withString:self.shopInfoModel.shopId];
        [self goWebViewWithUrl:url];
    }
}

//经营信息
- (void)businessInformationButtonAction{
    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_ManagementInfoController withData:nil];
}

//商铺公告
- (void)shopNoticesButtonAction{
    UIViewController *noticeVc =[[NSClassFromString(@"ShopNoticeViewController") alloc]init];
    noticeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeVc animated:YES];
}

//商铺实景
- (void)shopRealPhotoButtonAction{
    ShopSceneryViewController* shopshijing = [[ShopSceneryViewController alloc] init];
    [self.navigationController pushViewController:shopshijing animated:YES];
}

//商铺勋章
- (void)shopMedalAction{
    if (self.shopInfoModel.identifyUrl) {
        [self goWebViewWithUrl:self.shopInfoModel.identifyUrl];
    }
}
//交易得分
- (void)tradeScoreAction{
    if (self.shopInfoModel.tradeScoreUrl) {
        [self goWebViewWithUrl:self.shopInfoModel.tradeScoreUrl];
    }
}

//商铺认证
- (void)shopAuthenticationAction {
    if (self.shopInfoModel.shopQuaUrl) {
        [self goWebViewWithUrl:self.shopInfoModel.shopQuaUrl];
    }
}

//交易设置
- (void)tradeSettingAction {
    if (self.shopInfoModel.canTrade){
        [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_WYShopTradeSettingViewController withData:@{@"canTrade":self.shopInfoModel.canTrade}];
    }
}

//联系信息
-(void)setContactTip{
    ContactViewController *vc = [[ContactViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//银行账号
-(void)setBankAccountTip{
    BankAccountViewController *vc = [[BankAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark- Request
- (void)shopInfoRequest{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:@"" toView:self.view];
    [[[AppAPIHelper shareInstance] getShopAPI] getShopStoreShopInfoNewSuccess:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.shopInfoModel = data;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)myMarketAuthenticationRequest{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:@"" toView:self.view];
    [[[AppAPIHelper shareInstance] getUserModelAPI] getMarketQualiInfoWithSuccess:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        if ([[data allKeys] containsObject:@"url"]) {
            [weakSelf goWebViewWithUrl:[data objectForKey:@"url"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1){
        return 1;
    }else if (section == 2){
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        ShopInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopInfoTableViewCellID];
        [cell updateModel:self.shopInfoModel];
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        ShopFunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopFunctionTableViewCellID];
        [cell.businessInformationButton addTarget:self action:@selector(businessInformationButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.shopNoticesButton addTarget:self action:@selector(shopNoticesButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.shopRealPhotoButton addTarget:self action:@selector(shopRealPhotoButtonAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if(indexPath.section == 1){
        ShopInfoOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopInfoOtherTableViewCellID];
        [cell updateName:@"店铺勋章" content:self.shopInfoModel.identifyDesc score:@"" icons:self.shopInfoModel.identifys];
        return cell;
    }else if(indexPath.section == 2 && indexPath.row == 0){
        ShopInfoOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopInfoOtherTableViewCellID];
        [cell updateName:@"交易得分" content:@"得分明细" score:self.shopInfoModel.tradeScore icons:nil];
        return cell;
    }else{
        ShopInfoBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopInfoBaseTableViewCellID];
        NSString *value = @"";
        if (indexPath.section == 2 && indexPath.row == 1) {
            if (!self.shopInfoModel.quaRed) {
                value = @"未认证";
            }else{
                value = @"已认证";
            }
            [cell setName:@"市场认证" value:value isHiddenRed:YES];
        }else if (indexPath.section == 2 && indexPath.row == 2) {
            if (!self.shopInfoModel.tradeRed) {
                value = @"未设置";
            }else if(self.shopInfoModel.canTrade.integerValue){
                value = @"已打开在线交易";
            }else{
                value = @"您暂未打开在线交易";
            }
            [cell setName:@"交易设置" value:value isHiddenRed:self.shopInfoModel.tradeRed];
        }else if (indexPath.section == 3 && indexPath.row == 0) {
            if (!self.shopInfoModel.contactRed) {
                value = @"未设置";
            }else{
                value = @"已设置";
            }
            [cell setName:@"联系方式" value:value isHiddenRed:YES];
        }else if (indexPath.section == 3 && indexPath.row == 1) {
            if (!self.shopInfoModel.accountRed) {
                value = @"未设置";
            }else{
                value = @"已设置";
            }
            [cell setName:@"银行账号" value:value isHiddenRed:YES];
        }
        return cell;
    }
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0){
        return 84.0;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        return 82.0;
    }
    return 47.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0){
        [self shopMedalAction];
    }else if (indexPath.section == 2 && indexPath.row == 0){
        [self tradeScoreAction];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        [self shopAuthenticationAction];
    }else if (indexPath.section == 2 && indexPath.row == 2){
        [self tradeSettingAction];
    }else if (indexPath.section == 3 && indexPath.row == 0){
        [self setContactTip];
    }else if (indexPath.section == 3 && indexPath.row == 1){
        [self setBankAccountTip];
    }
}

#pragma Private

- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//分割线
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ShopInfoOtherTableViewCell" bundle:nil] forCellReuseIdentifier:ShopInfoOtherTableViewCellID];
    
    UIButton * shopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 28)];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithCustomView:shopButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [shopButton addTarget:self action:@selector(shopButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [shopButton setTitle:@"预览商铺" forState:UIControlStateNormal];
    [shopButton setTitleColor:[UIColor colorWithHex:0xE23728] forState:UIControlStateNormal];
    [shopButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
}

- (void)goWebViewWithUrl:(NSString *)url{
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
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
